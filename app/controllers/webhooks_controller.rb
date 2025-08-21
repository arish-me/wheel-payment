class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :verify_stripe_signature

  def stripe
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = ENV['STRIPE_WEBHOOK_SECRET']

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError => e
      Rails.logger.error "Invalid payload: #{e.message}"
      return head :bad_request
    rescue Stripe::SignatureVerificationError => e
      Rails.logger.error "Invalid signature: #{e.message}"
      return head :bad_request
    end

    # Handle the event
    case event['type']
    when 'payment_intent.succeeded'
      handle_payment_intent_succeeded(event['data']['object'])
    when 'payment_intent.payment_failed'
      handle_payment_intent_failed(event['data']['object'])
    when 'checkout.session.completed'
      handle_checkout_session_completed(event['data']['object'])
    when 'transfer.created'
      handle_transfer_created(event['data']['object'])
    when 'charge.refunded'
      handle_charge_refunded(event['data']['object'])
    else
      Rails.logger.info "Unhandled event type: #{event['type']}"
    end

    head :ok
  end

  private

  def verify_stripe_signature
    # Skip signature verification in development for testing
    return if Rails.env.development?
    
    # In production, you should always verify the signature
    # This is handled in the stripe method above
  end

  def handle_payment_intent_succeeded(payment_intent)
    milestone_id = payment_intent['metadata']['milestone_id']
    milestone = Milestone.find_by(id: milestone_id)
    
    return unless milestone

    # Update milestone status to funded
    milestone.update!(status: :funded)
    
    # Update transaction status
    transaction = Transaction.find_by(provider_id: payment_intent['id'])
    transaction&.update!(status: :completed)
    
    Rails.logger.info "Payment succeeded for milestone #{milestone_id}"
  end

  def handle_payment_intent_failed(payment_intent)
    milestone_id = payment_intent['metadata']['milestone_id']
    milestone = Milestone.find_by(id: milestone_id)
    
    return unless milestone

    # Update transaction status
    transaction = Transaction.find_by(provider_id: payment_intent['id'])
    transaction&.update!(status: :failed)
    
    Rails.logger.info "Payment failed for milestone #{milestone_id}"
  end

  def handle_checkout_session_completed(session)
    milestone_id = session['metadata']['milestone_id']
    milestone = Milestone.find_by(id: milestone_id)
    
    Rails.logger.info "Processing checkout.session.completed for milestone #{milestone_id}"
    
    return unless milestone

    begin
      # Update milestone status to funded
      if milestone.pending?
        milestone.update!(status: :funded)
        Rails.logger.info "Updated milestone #{milestone_id} to funded status"
      end
      
      # Update transaction status
      transaction = Transaction.find_by(provider_id: session['id'])
      if transaction
        transaction.update!(status: :completed)
        Rails.logger.info "Updated transaction #{transaction.id} to completed status"
      else
        Rails.logger.warn "No transaction found for session #{session['id']}"
      end
      
      Rails.logger.info "Checkout completed for milestone #{milestone_id}"
    rescue => e
      Rails.logger.error "Error processing checkout.session.completed: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
    end
  end

  def handle_transfer_created(transfer)
    milestone_id = transfer['metadata']['milestone_id']
    milestone = Milestone.find_by(id: milestone_id)
    
    return unless milestone

    # Update milestone status to released
    milestone.update!(status: :released)
    
    Rails.logger.info "Transfer created for milestone #{milestone_id}"
  end

  def handle_charge_refunded(charge)
    payment_intent_id = charge['payment_intent']
    transaction = Transaction.find_by(provider_id: payment_intent_id)
    
    return unless transaction

    milestone = transaction.milestone
    
    # Update milestone status to refunded
    milestone.update!(status: :refunded)
    
    # Update transaction status
    transaction.update!(status: :refunded)
    
    Rails.logger.info "Refund processed for milestone #{milestone.id}"
  end
end
