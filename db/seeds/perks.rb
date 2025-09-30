perks_data = [
  {
    partner_name: "Acme Cloud",
    category_name: "Cloud Infrastructure",
    sector_name: "SaaS",
    company_website: "https://acmecloud.example.com",
    contact_email: "alliances@acmecloud.example.com",
    contact: "Jordan Smith",
    tag_list: ["cloud", "storage", "infrastructure"]
  },
  {
    partner_name: "GrowthFuel Marketing",
    category_name: "Marketing",
    sector_name: "B2B",
    company_website: "https://growthfuel.example.com",
    contact_email: "partnerships@growthfuel.example.com",
    contact: "Priya Patel",
    tag_list: ["marketing", "demand generation", "lead gen"]
  },
  {
    partner_name: "LegalEase Advisors",
    category_name: "Legal",
    sector_name: "Professional Services",
    company_website: "https://legalease.example.com",
    contact_email: "hello@legalease.example.com",
    contact: "Carlos Alvarez",
    tag_list: ["legal", "contracts", "compliance"]
  },
  {
    partner_name: "FinSight Analytics",
    category_name: "Finance",
    sector_name: "FinTech",
    company_website: "https://finsight.example.com",
    contact_email: "team@finsight.example.com",
    contact: "Mei Chen",
    tag_list: ["finance", "analytics", "reporting"]
  },
  {
    partner_name: "TalentBridge HR",
    category_name: "Human Resources",
    sector_name: "Services",
    company_website: "https://talentbridge.example.com",
    contact_email: "partners@talentbridge.example.com",
    contact: "Omar Hassan",
    tag_list: ["hr", "recruiting", "benefits"]
  }
]

perks_data.each do |perk_attrs|
  attrs = perk_attrs.dup
  category = Category.find_or_create_by!(name: attrs.delete(:category_name))
  sector = Sector.find_or_create_by!(name: attrs.delete(:sector_name))
  tag_list = attrs.delete(:tag_list)

  perk = Perk.find_or_initialize_by(partner_name: attrs[:partner_name])
  perk.assign_attributes(attrs.merge(category:, sector:))
  perk.tag_list = tag_list if tag_list.present?
  perk.save!
  puts "Created/Updated perk: #{perk.partner_name}"
end

puts "Perk seeds completed successfully!"

