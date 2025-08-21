# Wheel Payment - Freelance Escrow Platform

A milestone-based freelance escrow platform built with Ruby on Rails 8, PostgreSQL, Tailwind CSS v4, and Stimulus.

## 🚀 Features

- **User Management**: Client, Developer, and Admin roles
- **Project Management**: Create and manage freelance projects
- **Milestone-based Payments**: Break down projects into fundable milestones
- **Stripe Integration**: Secure payment processing with Stripe Connect
- **Escrow System**: Funds held securely until milestone completion
- **Admin Dashboard**: Platform overview and management tools
- **Responsive Design**: Beautiful UI with Tailwind CSS

## 🛠 Tech Stack

- **Backend**: Ruby on Rails 8
- **Database**: PostgreSQL
- **Frontend**: Tailwind CSS v4, Stimulus
- **Authentication**: Devise
- **Payments**: Stripe
- **Background Jobs**: Sidekiq
- **Money Handling**: Money Rails

## 📋 Prerequisites

- Ruby 3.2.2 or higher
- PostgreSQL
- Node.js and Yarn
- Stripe account (for payments)

## 🔧 Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd wheel-payment
   ```

2. **Install dependencies**
   ```bash
   bundle install
   yarn install
   ```

3. **Setup database**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Configure environment variables**
   Create a `.env` file in the root directory with the following variables:
   ```bash
   # Database
   DATABASE_URL=postgresql://localhost/wheel_payment_development

   # Stripe Configuration
   STRIPE_SECRET_KEY=sk_test_your_stripe_secret_key_here
   STRIPE_PUBLISHABLE_KEY=pk_test_your_stripe_publishable_key_here
   STRIPE_WEBHOOK_SECRET=whsec_your_webhook_secret_here

   # Platform Configuration
   PLATFORM_FEE_PERCENT=5.0

   # Rails Configuration
   RAILS_ENV=development
   SECRET_KEY_BASE=your_secret_key_base_here
   ```

5. **Start the development server**
   ```bash
   bin/dev
   ```

## 🔑 Stripe Setup

### 1. Create a Stripe Account
- Sign up at [stripe.com](https://stripe.com)
- Get your API keys from the Stripe Dashboard

### 2. Configure Stripe Connect
- Enable Stripe Connect in your Stripe Dashboard
- Set up your Connect settings for marketplace payments

### 3. Set Up Webhooks
- In your Stripe Dashboard, go to Webhooks
- Add endpoint: `https://yourdomain.com/webhooks/stripe`
- Select these events:
  - `payment_intent.succeeded`
  - `payment_intent.payment_failed`
  - `checkout.session.completed`
  - `transfer.created`
  - `charge.refunded`
- Copy the webhook secret to your `.env` file

### 4. Test Mode
For development, use Stripe test keys:
- Test Secret Key: `sk_test_...`
- Test Publishable Key: `pk_test_...`
- Test webhook secret: `whsec_...`

## 🎯 Usage

### For Clients
1. **Sign up** as a client
2. **Create projects** and assign developers
3. **Add milestones** with descriptions and amounts
4. **Fund milestones** using Stripe Checkout
5. **Review completed work** and release payments
6. **Handle refunds** if needed

### For Developers
1. **Sign up** as a developer
2. **Complete Stripe Connect onboarding** to receive payments
3. **View assigned projects** and milestones
4. **Mark milestones as completed** when work is done
5. **Track payment status** and earnings

### For Admins
1. **Access admin dashboard** at `/admin/dashboard`
2. **Monitor platform statistics**
3. **Manage disputes** and transactions
4. **View user activity**

## 🔄 Payment Flow

1. **Client funds milestone** → Payment held in escrow
2. **Developer completes work** → Marks milestone as completed
3. **Client reviews work** → Approves and releases payment
4. **Developer receives payment** → Minus platform fee
5. **Platform collects fee** → Automatic fee deduction

## 🧪 Testing

```bash
# Run tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/models/user_spec.rb
```

## 🚀 Deployment

### Using Kamal (Recommended)
```bash
# Initialize Kamal
kamal init

# Deploy
kamal deploy
```

### Manual Deployment
1. Set up your production environment
2. Configure production database
3. Set production environment variables
4. Run migrations
5. Start the application

## 📁 Project Structure

```
app/
├── controllers/          # Application controllers
├── models/              # ActiveRecord models
├── services/            # Business logic services
├── views/               # ERB templates
└── javascript/          # Stimulus controllers

config/
├── routes.rb           # Application routes
├── initializers/       # Configuration files
└── environments/       # Environment-specific config

db/
├── migrate/            # Database migrations
└── seeds.rb           # Seed data
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Check the documentation
- Review the code comments

## 🔮 Roadmap

- [ ] Dispute resolution system
- [ ] Review and rating system
- [ ] File upload functionality
- [ ] Messaging system
- [ ] Time tracking
- [ ] Advanced reporting
- [ ] Mobile app
- [ ] Multi-currency support
