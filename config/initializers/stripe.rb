# frozen_string_literal: true

# Configure Stripe
Stripe.api_key = ENV['STRIPE_SECRET_KEY']

# Set API version
Stripe.api_version = '2024-12-18.acacia'

# Configure logging
Stripe.logger = Rails.logger if Rails.env.development?
