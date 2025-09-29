json.success true
json.message 'Sectors retrieved successfully'
json.data do
  json.sectors @sectors do |sector|
    json.partial! 'api/v1/sectors/shared/sector', sector: sector
  end
  json.has_next @sectors.next_page.present?
  json.total_count @total_count
  json.total_pages @sectors.total_pages
  json.per_page @sectors.limit_value
  json.current_page @sectors.current_page
end

