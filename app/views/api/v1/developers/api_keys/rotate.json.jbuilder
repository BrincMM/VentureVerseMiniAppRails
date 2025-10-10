json.success true
json.message 'API key rotated successfully'
json.data do
  json.api_key do
    json.id @api_key.id
    json.api_key @api_key.api_key
    json.app_id @api_key.app_id
    json.rate_limit_per_minute @api_key.rate_limit_per_minute
    json.rate_limit_per_day @api_key.rate_limit_per_day
    json.status @api_key.status
    json.expires_at @api_key.expires_at
    json.created_at @api_key.created_at
  end
end

