json.success true
json.message 'Apps retrieved successfully'
json.data do
  json.apps @apps do |app|
    json.partial! 'api/v1/apps/shared/app', app: app
  end
  json.has_next @apps.next_page.present?
  json.total_count @total_count
  json.total_pages @apps.total_pages
  json.per_page @apps.limit_value
  json.current_page @apps.current_page
end