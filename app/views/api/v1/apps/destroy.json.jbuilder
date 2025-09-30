json.success true
json.message 'App deleted successfully'
json.data do
  json.app do
    json.partial! 'api/v1/apps/shared/app', app: @app
  end
end

