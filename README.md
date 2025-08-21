# Wheel Payment - Freelance Escrow Platform

A secure milestone-based freelance escrow platform built with Ruby on Rails 8, PostgreSQL, Tailwind CSS v4, and Stimulus.

## Features

- **Milestone-based Payments**: Break down projects into milestones and fund them individually
- **Secure Escrow**: Funds are held securely until work is completed
- **Dispute Resolution**: Built-in dispute resolution system with admin mediation
- **Reviews & Ratings**: Rate and review developers after project completion
- **Multi-role Support**: Separate dashboards for clients, developers, and admins
- **Stripe Integration**: Secure payment processing with Stripe
- **Responsive Design**: Modern UI built with Tailwind CSS v4

## Tech Stack

- **Backend**: Ruby on Rails 8
- **Database**: PostgreSQL
- **Frontend**: Tailwind CSS v4, Stimulus
- **Authentication**: Devise
- **Payments**: Stripe
- **Background Jobs**: Sidekiq
- **Authorization**: Pundit
- **Money Handling**: Money Rails

## Prerequisites

- Ruby 3.2.2 or higher
- PostgreSQL
- Redis (for Sidekiq)
- Node.js and Yarn
- Stripe account

## Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd wheel-payment
   ```

2. **Install Ruby dependencies**
   ```bash
   bundle install
   ```

3. **Install JavaScript dependencies**
   ```bash
   yarn install
   ```

4. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

5. **Set up the database**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

6. **Build assets**
   ```bash
   yarn build:css
   yarn build
   ```

7. **Start the development server**
   ```bash
   bin/dev
   ```

## Environment Variables

Create a `.env` file with the following variables:

```env
# Database
DATABASE_URL=postgresql://localhost/wheel_payment_development

# Stripe Configuration
STRIPE_PUBLISHABLE_KEY=pk_test_your_stripe_publishable_key
STRIPE_SECRET_KEY=sk_test_your_stripe_secret_key
STRIPE_WEBHOOK_SECRET=whsec_your_stripe_webhook_secret

# Platform Configuration
PLATFORM_FEE_PERCENT=5

# Application Configuration
RAILS_ENV=development
SECRET_KEY_BASE=your_secret_key_base_here

# Redis (for Sidekiq)
REDIS_URL=redis://localhost:6379/0
```

## Usage

### User Roles

1. **Client**: Create projects, fund milestones, release payments, raise disputes
2. **Developer**: Work on projects, complete milestones, receive payments
3. **Admin**: Manage disputes, monitor transactions, platform administration

### Workflow

1. **Project Creation**: Client creates a project and assigns a developer
2. **Milestone Setup**: Client breaks down the project into milestones
3. **Funding**: Client funds individual milestones (money held in escrow)
4. **Development**: Developer works on the milestone
5. **Completion**: Developer marks milestone as complete
6. **Release**: Client reviews and releases payment to developer
7. **Review**: Client can rate and review the developer

## Development

### Running Tests
```bash
bundle exec rspec
```

### Code Quality
```bash
bundle exec rubocop
```

### Database
```bash
# Reset database
rails db:reset

# Run migrations
rails db:migrate

# Seed data
rails db:seed
```

## Deployment

The application is configured for deployment with Kamal. Update the deployment configuration in `config/deploy.yml` and deploy with:

```bash
kamal deploy
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For support, please open an issue in the GitHub repository.
