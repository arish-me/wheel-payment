class PaymentsController < ApplicationController
  before_action :authenticate_user!

  def create_checkout_session
    milestone = Milestone.find(params[:milestone_id])
    
    # Ensure the current user is the client for this milestone
    unless milestone.project.client == current_user
      redirect_to milestone.project, alert: 'You are not authorized to fund this milestone.'
      return
    end

    # Ensure the milestone can be funded
    unless milestone.can_be_funded?
      redirect_to milestone.project, alert: 'This milestone cannot be funded at this time.'
      return
    end

    # Check if Stripe is configured
    unless ENV['STRIPE_SECRET_KEY'].present?
      redirect_to milestone.project, alert: 'Payment processing is not configured. Please contact support.'
      return
    end

    stripe_service = StripeService.new
    
    success_url = payments_success_url(milestone_id: milestone.id)
    cancel_url = payments_cancel_url(milestone_id: milestone.id)
    
    begin
      session = stripe_service.create_checkout_session(milestone, current_user, success_url, cancel_url)
      
      # Redirect to Stripe Checkout
      redirect_to session.url, allow_other_host: true
    rescue Stripe::StripeError => e
      Rails.logger.error "Stripe error: #{e.message}"
      redirect_to milestone.project, alert: 'Payment processing error. Please try again.'
    rescue => e
      Rails.logger.error "Payment error: #{e.message}"
      redirect_to milestone.project, alert: 'An error occurred while processing your payment.'
    end
  end

  def success
    milestone_id = params[:milestone_id]
    milestone = Milestone.find_by(id: milestone_id)
    
    if milestone && milestone.project.client == current_user
      # For testing: Update milestone status directly
      # In production, this should be handled by webhooks
      if milestone.pending?
        milestone.update!(status: :funded)
        
        # Update the most recent transaction for this milestone
        transaction = milestone.transactions.order(:created_at).last
        if transaction
          transaction.update!(status: :completed)
          Rails.logger.info "Updated milestone #{milestone_id} to funded status"
        end
      end
      
      redirect_to milestone.project, notice: 'Payment successful! Your milestone has been funded.'
    else
      redirect_to dashboard_path, alert: 'Invalid payment confirmation.'
    end
  end

  def cancel
    milestone_id = params[:milestone_id]
    milestone = Milestone.find_by(id: milestone_id)
    
    if milestone && milestone.project.client == current_user
      redirect_to milestone.project, alert: 'Payment was cancelled.'
    else
      redirect_to dashboard_path, alert: 'Invalid payment cancellation.'
    end
  end
end
