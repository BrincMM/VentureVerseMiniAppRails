json.success true
json.message 'Apps retrieved successfully'
json.data do
  json.apps @apps do |app|
    json.partial! 'api/v1/developers/apps/shared/app', app: app
  end
  json.total_count @apps.size
end


