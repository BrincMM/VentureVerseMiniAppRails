json.success true
json.message 'App filters retrieved successfully'
json.data do
  json.used_categories @used_categories do |category|
    json.id category[:id]
    json.name category[:name]
    json.count category[:count]
  end

  json.used_sectors @used_sectors do |sector|
    json.id sector[:id]
    json.name sector[:name]
    json.count sector[:count]
  end

  json.used_tags @used_tags do |tag|
    json.name tag[:name]
    json.count tag[:count]
  end
end

