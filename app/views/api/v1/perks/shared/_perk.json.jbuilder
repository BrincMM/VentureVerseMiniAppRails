json.id perk.id
json.partner_name perk.partner_name
json.category do
  json.id perk.category_id
  json.name perk.category&.name
end
json.sector do
  json.id perk.sector_id
  json.name perk.sector&.name
end
json.company_website perk.company_website
json.contact_email perk.contact_email
json.contact perk.contact
json.tags perk.tag_list
json.created_at perk.created_at
json.updated_at perk.updated_at




