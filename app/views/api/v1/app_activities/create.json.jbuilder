json.success true
json.message 'Activity created successfully'
json.data do
  json.app_activity do
    json.partial! 'app_activity', app_activity: @app_activity
  end
end