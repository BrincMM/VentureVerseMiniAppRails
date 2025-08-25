# This file contains the seed data for the application
# It can be loaded with bin/rails db:seed

# Create Apps
apps_data = [
  {
    name: "Pitch Deck Analyzer",
    description: "Upload your pitchdeck and get instant feedback on fundability of your business.",
    category: "Business Strategy",
    sector: "Web 3",
    link: "https://drdeck.brincos.io/",
    tag_list: ["Pitching", "Fund Raising"],
    sort_order: 1
  },
  {
    name: "Pitch Coach",
    description: "Practice your pitch with different AI Investor.",
    category: "Business Strategy",
    sector: "Web 3",
    link: "https://pitchq.brincos.io/",
    tag_list: ["Pitching", "Fund Raising"],
    sort_order: 2
  },
  {
    name: "Tokenomics Builder",
    description: "Best tool to learn about tokenomics while building it.",
    category: "Business Strategy",
    sector: "Web 3",
    link: "https://tokenomics.brincos.io/landing",
    tag_list: ["Tokenomics", "Web 3", "Fund Raising"],
    sort_order: 3
  },
  {
    name: "Cap Table Visualizer",
    description: "Visualize your current cap table, build scenarios when receiving new investments.",
    category: "Business Strategy",
    sector: "General",
    link: "https://capviz.replit.app/",
    tag_list: ["Fund Raising", "Cap Table"],
    sort_order: 4
  },
  {
    name: "Termsheet Analyzer",
    description: "Quick risk analysis tool for your termsheet.",
    category: "Legal",
    sector: "Web 3",
    link: "https://termsheets.brincos.io/",
    tag_list: ["Termsheet", "Risk Management"],
    sort_order: 5
  },
  {
    name: "Token Utility Planner",
    description: "Plan your token utility.",
    category: "Business Strategy",
    sector: "Web 3",
    link: "https://utility.brincos.io/",
    tag_list: ["Tokenomic", "Web 3"],
    sort_order: 6
  }
]

# Create or update apps
apps_data.each do |app_data|
  app = App.find_or_initialize_by(name: app_data[:name])
  app.update!(
    description: app_data[:description],
    category: app_data[:category],
    sector: app_data[:sector],
    link: app_data[:link],
    tag_list: app_data[:tag_list],
    sort_order: app_data[:sort_order]
  )
  puts "Created/Updated app: #{app.name}"
end

# Create test user
user = User.find_or_initialize_by(email: 'mafai.ma@brinc.io')
if user.new_record?
  user.update!(
    first_name: 'Mafai',
    last_name: 'Ma',
    age_consent: true,
    password: 'password123',
    password_confirmation: 'password123',
    monthly_credit_balance: 1000
  )
  puts "Created test user: #{user.email}"
else
  puts "Test user already exists: #{user.email}"
end

# Create tiers with correct price IDs
tiers_data = [
  {
    name: 'Launch',
    stripe_price_id: 'price_1RxNPYRjEJjLBLjEbYn0WhbN',
    monthly_credit: 100.00,
    monthly_tier_price: 9.99,
    yearly_tier_price: 99.99,
    active: true
  },
  {
    name: 'Fly',
    stripe_price_id: 'price_1RxNUZRjEJjLBLjE0dHA6ODF',
    monthly_credit: 500.00,
    monthly_tier_price: 29.99,
    yearly_tier_price: 299.99,
    active: true
  },
  {
    name: 'Soar',
    stripe_price_id: 'price_1RxNWtRjEJjLBLjE6e2WnCjF',
    monthly_credit: 1000.00,
    monthly_tier_price: 49.99,
    yearly_tier_price: 499.99,
    active: true
  }
]

tiers_data.each do |tier_data|
  tier = Tier.find_or_initialize_by(name: tier_data[:name])
  tier.update!(
    stripe_price_id: tier_data[:stripe_price_id],
    monthly_credit: tier_data[:monthly_credit],
    monthly_tier_price: tier_data[:monthly_tier_price],
    yearly_tier_price: tier_data[:yearly_tier_price],
    active: tier_data[:active]
  )
  puts "Created/Updated tier: #{tier.name}"
end

puts "Seed completed successfully!"