json.id app.id
json.app_name app.name
json.description app.description
json.category do
  json.id app.category_id
  json.name app.category&.name
end
json.sector do
  json.id app.sector_id
  json.name app.sector&.name
end
json.link app.link
json.tags app.tag_list
json.created_at app.created_at
json.updated_at app.updated_at