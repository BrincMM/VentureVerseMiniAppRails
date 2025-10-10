json.success true
json.message 'API key is valid'
json.data do
  json.api_key do
    json.id @api_key.id
    json.status @api_key.status
    json.rate_limit_per_minute @api_key.rate_limit_per_minute
    json.rate_limit_per_day @api_key.rate_limit_per_day
    json.expires_at @api_key.expires_at
    json.last_used_at @api_key.last_used_at
  end
  
  json.app do
    json.id @app.id
    json.name @app.name
    json.status @app.status
    json.rate_limit_requests_per_day @app.rate_limit_requests_per_day
    json.rate_limit_requests_per_minute @app.rate_limit_requests_per_minute
  end
  
  if @developer
    json.developer do
      json.id @developer.id
      json.email @developer.email
      json.name @developer.name
    end
  end
end

