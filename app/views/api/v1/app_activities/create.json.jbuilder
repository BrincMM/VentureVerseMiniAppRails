json.success true
json.message 'App activity created successfully'
json.data do
  json.app_activity do
    json.partial! 'api/v1/app_activities/app_activity', app_activity: @app_activity
  end
end