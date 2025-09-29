json.success true
json.message 'Category updated successfully'
json.data do
  json.category do
    json.partial! 'api/v1/categories/shared/category', category: @category
  end
end

