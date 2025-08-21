# Stripe Setup Guide for Wheel Payment

This guide will help you set up Stripe payments for the Wheel Payment escrow platform.

## Prerequisites

1. A Stripe account (sign up at [stripe.com](https://stripe.com))
2. Access to your Stripe Dashboard
3. The application running locally

## Step 1: Get Your Stripe API Keys

1. Log in to your [Stripe Dashboard](https://dashboard.stripe.com/)
2. Go to **Developers** → **API keys**
3. Copy your **Publishable key** and **Secret key**
4. For testing, use the keys that start with `pk_test_` and `sk_test_`

## Step 2: Set Up Environment Variables

Create a `.env` file in your project root with the following variables:

```bash
# Stripe Configuration
STRIPE_SECRET_KEY=sk_test_your_secret_key_here
STRIPE_PUBLISHABLE_KEY=pk_test_your_publishable_key_here
STRIPE_WEBHOOK_SECRET=whsec_your_webhook_secret_here

# Platform Configuration
PLATFORM_FEE_PERCENT=5.0
```

## Step 3: Enable Stripe Connect

1. In your Stripe Dashboard, go to **Connect** → **Settings**
2. Enable **Connect** if not already enabled
3. Configure your Connect settings for marketplace payments

## Step 4: Set Up Webhooks

1. In your Stripe Dashboard, go to **Developers** → **Webhooks**
2. Click **Add endpoint**
3. Set the endpoint URL to: `https://yourdomain.com/webhooks/stripe`
   - For local development: `http://localhost:3000/webhooks/stripe`
4. Select these events:
   - `payment_intent.succeeded`
   - `payment_intent.payment_failed`
   - `checkout.session.completed`
   - `transfer.created`
   - `charge.refunded`
5. Click **Add endpoint**
6. Copy the **Signing secret** (starts with `whsec_`) to your `.env` file

## Step 5: Test the Integration

### For Local Development

1. Start your Rails server: `bin/dev`
2. Sign up as a client and create a project
3. Add a milestone with an amount
4. Click "Fund with Stripe" to test the payment flow
5. Use Stripe's test card numbers:
   - **Success**: `4242 4242 4242 4242`
   - **Decline**: `4000 0000 0000 0002`
   - **Expiry**: Any future date
   - **CVC**: Any 3 digits

### For Developers

1. Sign up as a developer
2. Go to your dashboard and click "Setup Stripe Connect"
3. Complete the Stripe Connect onboarding
4. You'll now be able to receive payments

## Step 6: Production Setup

When deploying to production:

1. Switch to **Live mode** in your Stripe Dashboard
2. Get your live API keys (start with `pk_live_` and `sk_live_`)
3. Update your environment variables with live keys
4. Set up production webhooks with your live domain
5. Ensure your domain has SSL (https://)

## Testing Checklist

- [ ] Client can create projects and milestones
- [ ] Client can fund milestones using Stripe Checkout
- [ ] Payment appears in Stripe Dashboard
- [ ] Developer can complete milestones
- [ ] Client can release payments to developer
- [ ] Developer receives payment (minus platform fee)
- [ ] Refunds work correctly
- [ ] Webhooks update milestone status automatically

## Common Issues

### "Invalid API key" error
- Check that your `STRIPE_SECRET_KEY` is correct
- Ensure you're using test keys for development

### "Webhook signature verification failed"
- Verify your `STRIPE_WEBHOOK_SECRET` is correct
- Check that webhook endpoint URL is accessible

### "Connect account not found"
- Ensure the developer has completed Stripe Connect onboarding
- Check that Connect is enabled in your Stripe Dashboard

### Payment not appearing in dashboard
- Check webhook logs in Stripe Dashboard
- Verify webhook endpoint is receiving events
- Check Rails logs for webhook processing errors

## Support

- [Stripe Documentation](https://stripe.com/docs)
- [Stripe Connect Guide](https://stripe.com/docs/connect)
- [Stripe Webhooks](https://stripe.com/docs/webhooks)

## Security Notes

- Never commit your `.env` file to version control
- Use test keys for development
- Always verify webhook signatures in production
- Keep your API keys secure
