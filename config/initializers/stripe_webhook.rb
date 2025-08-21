# frozen_string_literal: true

# Development webhook simulation
if Rails.env.development?
  # Create a simple webhook secret for development
  ENV['STRIPE_WEBHOOK_SECRET'] ||= 'whsec_development_secret'
  
  Rails.logger.info "Development webhook secret set: #{ENV['STRIPE_WEBHOOK_SECRET']}"
end
