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

puts "Seed completed successfully!"