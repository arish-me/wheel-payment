class DeveloperOnboardingController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_developer

  def stripe_connect
    begin
      stripe_service = StripeService.new
      account_link = stripe_service.create_account_link(current_user)
      
      redirect_to account_link.url, allow_other_host: true
    rescue Stripe::StripeError => e
      Rails.logger.error "Stripe Connect error: #{e.message}"
      redirect_to dashboard_path, alert: 'Failed to create Stripe Connect account. Please try again.'
    rescue => e
      Rails.logger.error "Onboarding error: #{e.message}"
      redirect_to dashboard_path, alert: 'An error occurred during onboarding.'
    end
  end

  private

  def ensure_developer
    unless current_user.developer?
      redirect_to dashboard_path, alert: 'Only developers can access this page.'
    end
  end
end
