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
json.rate_limit_requests_per_day app.rate_limit_requests_per_day
json.rate_limit_requests_per_minute app.rate_limit_requests_per_minute
json.tags app.tag_list
json.created_at app.created_at
json.updated_at app.updated_at

