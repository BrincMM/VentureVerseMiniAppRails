json.success true
json.message 'Tiers retrieved successfully'
json.data do
  json.tiers @tiers do |tier|
    json.id tier.id
    json.name tier.name
    json.stripe_price_id tier.stripe_price_id
    json.active tier.active
    json.monthly_tier_price tier.monthly_tier_price
    json.created_at tier.created_at
    json.updated_at tier.updated_at
  end
end