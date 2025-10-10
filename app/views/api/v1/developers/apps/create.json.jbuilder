json.success true
json.message 'App created successfully'
json.data do
  json.app do
    json.partial! 'api/v1/developers/apps/shared/app', app: @app
  end
end

