class StripeService
  include ActiveSupport::Configurable

  config_accessor :stripe_secret_key, :stripe_publishable_key, :platform_fee_percent

  def initialize
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    @platform_fee_percent = ENV.fetch('PLATFORM_FEE_PERCENT', 5).to_f
  end

  # Create a payment intent for funding a milestone
  def create_payment_intent(milestone, client)
    amount = milestone.amount_cents
    fee_amount = calculate_platform_fee(amount)
    
    payment_intent = Stripe::PaymentIntent.create(
      amount: amount,
      currency: milestone.currency.downcase,
      metadata: {
        milestone_id: milestone.id,
        project_id: milestone.project.id,
        client_id: client.id,
        developer_id: milestone.project.developer.id,
        fee_amount: fee_amount
      },
      application_fee_amount: fee_amount,
      transfer_data: {
        destination: get_or_create_stripe_account(milestone.project.developer),
      },
      capture_method: 'manual', # Don't capture immediately, wait for milestone completion
      confirm: false
    )

    # Create transaction record
    Transaction.create!(
      milestone: milestone,
      payment_provider: :stripe,
      provider_id: payment_intent.id,
      status: :pending,
      fee_cents: fee_amount,
      net_amount_cents: amount - fee_amount
    )

    payment_intent
  end

  # Capture a payment intent (fund the milestone)
  def capture_payment_intent(payment_intent_id)
    payment_intent = Stripe::PaymentIntent.retrieve(payment_intent_id)
    payment_intent.capture
    
    # Update transaction status
    transaction = Transaction.find_by!(provider_id: payment_intent_id)
    transaction.update!(status: :completed)
    
    payment_intent
  end

  # Release funds to developer (transfer to connected account)
  def release_milestone(milestone)
    # Find the most recent transaction for this milestone
    transaction = milestone.transactions.order(:created_at).last
    return false unless transaction

    Rails.logger.info "Processing release for milestone #{milestone.id}, transaction #{transaction.id}"

    begin
      # Check if developer has Stripe Connect account
      developer = milestone.project.developer
      
      if developer.stripe_account_id.present?
        # Create actual transfer to developer's connected account
        if transaction.provider_id.start_with?('cs_') # Checkout session
          session = Stripe::Checkout::Session.retrieve(transaction.provider_id)
          payment_intent_id = session.payment_intent
          
          if payment_intent_id
            payment_intent = Stripe::PaymentIntent.retrieve(payment_intent_id)
            charge = payment_intent.charges.first
            
            if charge
              transfer = Stripe::Transfer.create(
                amount: transaction.net_amount_cents,
                currency: milestone.currency.downcase,
                destination: developer.stripe_account_id,
                source_transaction: charge.id,
                metadata: {
                  milestone_id: milestone.id,
                  project_id: milestone.project.id,
                  developer_id: developer.id
                }
              )
              Rails.logger.info "Created Stripe transfer: #{transfer.id}"
            else
              Rails.logger.error "No charge found for payment intent #{payment_intent_id}"
              return false
            end
          else
            Rails.logger.error "No payment intent found for session #{transaction.provider_id}"
            return false
          end
        else
          # Direct payment intent transfer
          payment_intent = Stripe::PaymentIntent.retrieve(transaction.provider_id)
          charge = payment_intent.charges.first
          
          if charge
            transfer = Stripe::Transfer.create(
              amount: transaction.net_amount_cents,
              currency: milestone.currency.downcase,
              destination: developer.stripe_account_id,
              source_transaction: charge.id,
              metadata: {
                milestone_id: milestone.id,
                project_id: milestone.project.id,
                developer_id: developer.id
              }
            )
            Rails.logger.info "Created Stripe transfer: #{transfer.id}"
          else
            Rails.logger.error "No charge found for payment intent #{transaction.provider_id}"
            return false
          end
        end
        
        # Update transaction status
        transaction.update_column(:status, :completed)
        Rails.logger.info "Milestone #{milestone.id} released successfully with transfer"
        true
      else
        # Developer doesn't have Stripe Connect - testing mode
        Rails.logger.info "Developer #{developer.id} doesn't have Stripe Connect - testing mode"
        transaction.update_column(:status, :completed)
        Rails.logger.info "Milestone #{milestone.id} released (testing mode - no actual transfer)"
        true
      end
      
    rescue Stripe::StripeError => e
      Rails.logger.error "Stripe release error: #{e.message}"
      false
    rescue => e
      Rails.logger.error "Release error: #{e.message}"
      false
    end
  end

  # Refund a milestone
  def refund_milestone(milestone)
    # Find the most recent transaction for this milestone
    transaction = milestone.transactions.order(:created_at).last
    return false unless transaction

    Rails.logger.info "Processing refund for milestone #{milestone.id}, transaction #{transaction.id}"

    begin
      # Create actual Stripe refund
      if transaction.provider_id.start_with?('cs_') # Checkout session
        # For checkout sessions, we need to get the payment intent first
        session = Stripe::Checkout::Session.retrieve(transaction.provider_id)
        payment_intent_id = session.payment_intent
        
        if payment_intent_id
          refund = Stripe::Refund.create(
            payment_intent: payment_intent_id,
            metadata: {
              milestone_id: milestone.id,
              project_id: milestone.project.id,
              client_id: milestone.project.client.id
            }
          )
          Rails.logger.info "Created Stripe refund: #{refund.id}"
        else
          Rails.logger.error "No payment intent found for session #{transaction.provider_id}"
          return false
        end
      else
        # Direct payment intent refund
        refund = Stripe::Refund.create(
          payment_intent: transaction.provider_id,
          metadata: {
            milestone_id: milestone.id,
            project_id: milestone.project.id,
            client_id: milestone.project.client.id
          }
        )
        Rails.logger.info "Created Stripe refund: #{refund.id}"
      end

      # Update transaction status
      transaction.update_column(:status, :refunded)
      
      Rails.logger.info "Milestone #{milestone.id} refunded successfully"
      true
      
    rescue Stripe::StripeError => e
      Rails.logger.error "Stripe refund error: #{e.message}"
      false
    rescue => e
      Rails.logger.error "Refund error: #{e.message}"
      false
    end
  end

  # Create or get Stripe Connect account for developer
  def create_connect_account(developer)
    account = Stripe::Account.create(
      type: 'express',
      country: 'US', # Default, should be configurable
      email: developer.email,
      capabilities: {
        card_payments: { requested: true },
        transfers: { requested: true }
      },
      metadata: {
        developer_id: developer.id
      }
    )

    # Store the account ID in the developer record
    developer.update!(stripe_account_id: account.id)
    
    account
  end

  # Get account link for onboarding
  def create_account_link(developer)
    account_id = get_or_create_stripe_account(developer)
    
    Stripe::AccountLink.create(
      account: account_id,
      refresh_url: Rails.application.routes.url_helpers.dashboard_url,
      return_url: Rails.application.routes.url_helpers.dashboard_url,
      type: 'account_onboarding'
    )
  end

  # Create checkout session for milestone funding
  def create_checkout_session(milestone, client, success_url, cancel_url)
    amount = milestone.amount_cents
    fee_amount = calculate_platform_fee(amount)

    # For testing without Connect, we'll create a simple checkout session
    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        price_data: {
          currency: milestone.currency.downcase,
          product_data: {
            name: milestone.title,
            description: milestone.description
          },
          unit_amount: amount
        },
        quantity: 1
      }],
      mode: 'payment',
      success_url: success_url,
      cancel_url: cancel_url,
      metadata: {
        milestone_id: milestone.id,
        project_id: milestone.project.id,
        client_id: client.id,
        developer_id: milestone.project.developer.id
      }
    )

    # Create transaction record
    Transaction.create!(
      milestone: milestone,
      payment_provider: :stripe,
      provider_id: session.id,
      status: :pending,
      fee_cents: fee_amount,
      net_amount_cents: amount - fee_amount
    )

    session
  end

  private

  def calculate_platform_fee(amount)
    (amount * @platform_fee_percent / 100.0).round
  end

  def get_or_create_stripe_account(developer)
    return developer.stripe_account_id if developer.stripe_account_id.present?
    
    account = create_connect_account(developer)
    account.id
  end
end
