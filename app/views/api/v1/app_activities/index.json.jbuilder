json.success true
json.message 'Activities retrieved successfully'
json.data do
  json.activities @app_activities do |app_activity|
    json.partial! 'app_activity', app_activity: app_activity
  end
  json.has_next @app_activities.next_page.present?
  json.total_count @total_count
  json.total_pages @app_activities.total_pages
  json.per_page @app_activities.limit_value
  json.current_page @app_activities.current_page
end