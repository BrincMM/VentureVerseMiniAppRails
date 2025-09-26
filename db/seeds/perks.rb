perks_data = [
  {
    partner_name: "Acme Cloud",
    category: "Cloud Infrastructure",
    sector: "SaaS",
    company_website: "https://acmecloud.example.com",
    contact_email: "alliances@acmecloud.example.com",
    contact: "Jordan Smith",
    tag_list: ["cloud", "storage", "infrastructure"]
  },
  {
    partner_name: "GrowthFuel Marketing",
    category: "Marketing",
    sector: "B2B",
    company_website: "https://growthfuel.example.com",
    contact_email: "partnerships@growthfuel.example.com",
    contact: "Priya Patel",
    tag_list: ["marketing", "demand generation", "lead gen"]
  },
  {
    partner_name: "LegalEase Advisors",
    category: "Legal",
    sector: "Professional Services",
    company_website: "https://legalease.example.com",
    contact_email: "hello@legalease.example.com",
    contact: "Carlos Alvarez",
    tag_list: ["legal", "contracts", "compliance"]
  },
  {
    partner_name: "FinSight Analytics",
    category: "Finance",
    sector: "FinTech",
    company_website: "https://finsight.example.com",
    contact_email: "team@finsight.example.com",
    contact: "Mei Chen",
    tag_list: ["finance", "analytics", "reporting"]
  },
  {
    partner_name: "TalentBridge HR",
    category: "Human Resources",
    sector: "Services",
    company_website: "https://talentbridge.example.com",
    contact_email: "partners@talentbridge.example.com",
    contact: "Omar Hassan",
    tag_list: ["hr", "recruiting", "benefits"]
  }
]

perks_data.each do |perk_attrs|
  perk = Perk.find_or_initialize_by(partner_name: perk_attrs[:partner_name])
  perk.update!(perk_attrs)
  puts "Created/Updated perk: #{perk.partner_name}"
end

puts "Perk seeds completed successfully!"

