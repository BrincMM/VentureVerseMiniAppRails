json.success true
json.message 'Categories retrieved successfully'
json.data do
  json.categories @categories do |category|
    json.partial! 'api/v1/categories/shared/category', category: category
  end
  json.has_next @categories.next_page.present?
  json.total_count @total_count
  json.total_pages @categories.total_pages
  json.per_page @categories.limit_value
  json.current_page @categories.current_page
end

