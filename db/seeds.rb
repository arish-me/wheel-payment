# Clear existing data
puts "Clearing existing data..."
Review.destroy_all
Dispute.destroy_all
Transaction.destroy_all
Milestone.destroy_all
Project.destroy_all
User.destroy_all

# Create users
puts "Creating users..."

# Admin user
admin = User.create!(
  email: 'admin@wheelpayment.com',
  password: 'password123',
  password_confirmation: 'password123',
  role: :admin
)

# Client users
client1 = User.create!(
  email: 'client1@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  role: :client
)

client2 = User.create!(
  email: 'client2@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  role: :client
)

# Developer users
developer1 = User.create!(
  email: 'developer1@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  role: :developer
)

developer2 = User.create!(
  email: 'developer2@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  role: :developer
)

puts "Created users:"
puts "- Admin: #{admin.email}"
puts "- Clients: #{client1.email}, #{client2.email}"
puts "- Developers: #{developer1.email}, #{developer2.email}"

# Create projects
puts "\nCreating projects..."

project1 = Project.create!(
  title: 'E-commerce Website Development',
  description: 'Build a modern e-commerce website with React frontend and Rails API backend. Include user authentication, product catalog, shopping cart, and payment integration.',
  client: client1,
  developer: developer1,
  status: :active
)

project2 = Project.create!(
  title: 'Mobile App for Food Delivery',
  description: 'Develop a cross-platform mobile app for food delivery service. Features include user registration, restaurant listings, order placement, real-time tracking, and payment processing.',
  client: client2,
  developer: developer2,
  status: :active
)

project3 = Project.create!(
  title: 'CRM System for Small Business',
  description: 'Create a customer relationship management system tailored for small businesses. Include contact management, lead tracking, sales pipeline, and reporting features.',
  client: client1,
  developer: developer2,
  status: :draft
)

puts "Created projects:"
puts "- #{project1.title} (Client: #{project1.client.email}, Developer: #{project1.developer.email})"
puts "- #{project2.title} (Client: #{project2.client.email}, Developer: #{project2.developer.email})"
puts "- #{project3.title} (Client: #{project3.client.email}, Developer: #{project3.developer.email})"

# Create milestones
puts "\nCreating milestones..."

# Project 1 milestones
milestone1_1 = Milestone.create!(
  title: 'Design and Wireframes',
  description: 'Create UI/UX designs and wireframes for the e-commerce website. Include homepage, product pages, cart, and checkout flow.',
  amount_cents: 250000, # $2,500
  currency: 'USD',
  project: project1,
  status: :funded
)

milestone1_2 = Milestone.create!(
  title: 'Frontend Development',
  description: 'Build the React frontend with responsive design, product catalog, and user authentication.',
  amount_cents: 500000, # $5,000
  currency: 'USD',
  project: project1,
  status: :pending
)

milestone1_3 = Milestone.create!(
  title: 'Backend API Development',
  description: 'Develop the Rails API backend with user management, product management, and order processing.',
  amount_cents: 400000, # $4,000
  currency: 'USD',
  project: project1,
  status: :pending
)

# Project 2 milestones
milestone2_1 = Milestone.create!(
  title: 'App Design and Prototyping',
  description: 'Design the mobile app interface and create interactive prototypes for user testing.',
  amount_cents: 300000, # $3,000
  currency: 'USD',
  project: project2,
  status: :completed
)

milestone2_2 = Milestone.create!(
  title: 'Core App Development',
  description: 'Develop the core app functionality including user authentication, restaurant listings, and basic navigation.',
  amount_cents: 600000, # $6,000
  currency: 'USD',
  project: project2,
  status: :funded
)

milestone2_3 = Milestone.create!(
  title: 'Order and Payment System',
  description: 'Implement order placement, payment processing, and real-time order tracking features.',
  amount_cents: 450000, # $4,500
  currency: 'USD',
  project: project2,
  status: :pending
)

puts "Created milestones:"
puts "- Project 1: #{milestone1_1.title} ($#{milestone1_1.amount_cents / 100}) - #{milestone1_1.status}"
puts "- Project 1: #{milestone1_2.title} ($#{milestone1_2.amount_cents / 100}) - #{milestone1_2.status}"
puts "- Project 1: #{milestone1_3.title} ($#{milestone1_3.amount_cents / 100}) - #{milestone1_3.status}"
puts "- Project 2: #{milestone2_1.title} ($#{milestone2_1.amount_cents / 100}) - #{milestone2_1.status}"
puts "- Project 2: #{milestone2_2.title} ($#{milestone2_2.amount_cents / 100}) - #{milestone2_2.status}"
puts "- Project 2: #{milestone2_3.title} ($#{milestone2_3.amount_cents / 100}) - #{milestone2_3.status}"

# Create sample transactions
puts "\nCreating sample transactions..."

Transaction.create!(
  milestone: milestone1_1,
  payment_provider: :stripe,
  provider_id: 'pi_sample_123',
  status: :completed,
  fee_cents: 12500, # $125 (5% platform fee)
  net_amount_cents: 237500 # $2,375
)

Transaction.create!(
  milestone: milestone2_1,
  payment_provider: :stripe,
  provider_id: 'pi_sample_456',
  status: :completed,
  fee_cents: 15000, # $150 (5% platform fee)
  net_amount_cents: 285000 # $2,850
)

Transaction.create!(
  milestone: milestone2_2,
  payment_provider: :stripe,
  provider_id: 'pi_sample_789',
  status: :processing,
  fee_cents: 30000, # $300 (5% platform fee)
  net_amount_cents: 570000 # $5,700
)

puts "Created sample transactions for funded milestones"

# Create sample reviews
puts "\nCreating sample reviews..."

# First, let's release a milestone so we can create a review
milestone2_1.update!(status: :released)

Review.create!(
  milestone: milestone2_1,
  reviewer: client2,
  reviewed: developer2,
  rating: 5,
  comment: 'Excellent work on the app design! The prototypes were very well thought out and the user experience is intuitive. Highly recommend this developer.'
)

puts "Created sample review for completed milestone"

puts "\nSeed data created successfully!"
puts "\nYou can now log in with:"
puts "- Admin: admin@wheelpayment.com / password123"
puts "- Client: client1@example.com / password123"
puts "- Developer: developer1@example.com / password123"
