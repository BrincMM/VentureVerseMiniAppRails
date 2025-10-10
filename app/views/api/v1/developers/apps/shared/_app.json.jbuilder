json.id app.id
json.name app.name
json.description app.description
json.category do
  json.id app.category_id
  json.name app.category&.name
end
json.sector do
  json.id app.sector_id
  json.name app.sector&.name
end
json.app_url app.app_url
json.status app.status
json.developer_id app.developer_id
json.rate_limit_max_requests app.rate_limit_max_requests
json.rate_limit_window_ms app.rate_limit_window_ms
json.tags app.tag_list
json.created_at app.created_at
json.updated_at app.updated_at

# Include active API keys
json.api_keys app.api_keys.active do |api_key|
  json.id api_key.id
  json.api_key api_key.api_key
  json.rate_limit_per_minute api_key.rate_limit_per_minute
  json.rate_limit_per_day api_key.rate_limit_per_day
  json.status api_key.status
  json.expires_at api_key.expires_at
  json.last_used_at api_key.last_used_at
  json.created_at api_key.created_at
end

