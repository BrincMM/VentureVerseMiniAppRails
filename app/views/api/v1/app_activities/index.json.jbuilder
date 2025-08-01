json.success true
json.message 'App activities retrieved successfully'
json.data do
  json.app_activities do
    json.array! @app_activities, partial: 'api/v1/app_activities/app_activity', as: :app_activity
  end
  json.has_next @app_activities.next_page.present?
  json.total_count @total_count
  json.total_pages @app_activities.total_pages
  json.per_page @app_activities.limit_value
  json.current_page @app_activities.current_page
end