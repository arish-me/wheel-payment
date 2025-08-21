#!/usr/bin/env ruby

# This script helps set up Stripe webhooks for testing
# Run this after setting up your Stripe account

require 'stripe'

# Set your Stripe secret key
Stripe.api_key = ""

puts "Setting up Stripe webhook for localhost:3000/webhooks/stripe..."

begin
  # Create webhook endpoint
  webhook = Stripe::WebhookEndpoint.create({
    url: 'http://localhost:3000/webhooks/stripe',
    enabled_events: [
      'checkout.session.completed',
      'payment_intent.succeeded',
      'payment_intent.payment_failed',
      'charge.refunded'
    ]
  })

  puts "✅ Webhook created successfully!"
  puts "Webhook ID: #{webhook.id}"
  puts "Webhook Secret: #{webhook.secret}"
  puts ""
  puts "Add this to your .env file:"
  puts "STRIPE_WEBHOOK_SECRET=#{webhook.secret}"
  puts ""
  puts "Or set it as an environment variable:"
  puts "export STRIPE_WEBHOOK_SECRET=#{webhook.secret}"

rescue Stripe::StripeError => e
  puts "❌ Error creating webhook: #{e.message}"
  puts ""
  puts "Make sure you have:"
  puts "1. Set STRIPE_SECRET_KEY environment variable"
  puts "2. Have a valid Stripe account"
  puts "3. Are using test keys for development"
end
