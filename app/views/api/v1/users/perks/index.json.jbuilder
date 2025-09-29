json.success true
json.message 'User perks retrieved successfully'
json.data do
  json.perks @perks do |perk|
    json.partial! 'api/v1/perks/shared/perk', perk: perk
  end
  json.has_next @perks.next_page.present?
  json.total_count @total_count
  json.total_pages @perks.total_pages
  json.per_page @perks.limit_value
  json.current_page @perks.current_page
end




