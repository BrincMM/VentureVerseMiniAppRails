# This file contains the seed data for the application
# It can be loaded with bin/rails db:seed

# Create Apps
apps_data = [
  {
    name: "Pitch Deck Analyzer",
    description: "Upload your pitch deck and get AI feedback on structure and content",
    category: "Startup Tools",
    sector: "Pitch & Presentation",
    tag_list: ["pitch deck", "AI feedback", "startup"]
  },
  {
    name: "Pitch Coach",
    description: "Practice pitching with simulated VC feedback and scoring",
    category: "Startup Tools",
    sector: "Pitch & Presentation",
    tag_list: ["pitch practice", "VC feedback", "simulation"]
  },
  {
    name: "Tokenomics Builder",
    description: "Design and simulate token vesting models and allocations",
    category: "Startup Tools",
    sector: "Blockchain & Tokenomics",
    tag_list: ["tokenomics", "vesting", "token allocation"]
  },
  {
    name: "Cap Table Visualizer",
    description: "Model funding rounds and visualize equity dilution",
    category: "Startup Tools",
    sector: "Finance & Equity",
    tag_list: ["cap table", "equity", "funding rounds"]
  },
  {
    name: "Termsheet Analyzer",
    description: "Analyze and find risk in your termsheets based on your company profile!",
    category: "Startup Tools",
    sector: "Legal & Finance",
    tag_list: ["termsheet", "risk analysis", "legal"]
  },
  {
    name: "Token Utility Planner",
    description: "Build your tokenomics!",
    category: "Startup Tools",
    sector: "Blockchain & Tokenomics",
    tag_list: ["token utility", "tokenomics", "blockchain"]
  }
]

# Create or update apps
apps_data.each do |app_data|
  app = App.find_or_initialize_by(name: app_data[:name])
  app.update!(
    description: app_data[:description],
    category: app_data[:category],
    sector: app_data[:sector],
    tag_list: app_data[:tag_list]
  )
  puts "Created/Updated app: #{app.name}"
end

puts "Seed completed successfully!"