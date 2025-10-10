json.success true
json.message 'App disabled successfully'
json.data do
  json.app do
    json.id @app.id
    json.status @app.status
  end
end

