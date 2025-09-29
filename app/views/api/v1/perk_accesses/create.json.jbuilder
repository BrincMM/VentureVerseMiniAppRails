json.success true
json.message 'Perk access granted successfully'
json.data do
  json.perk_access do
    json.id @perk_access.id
    json.user_id @perk_access.user_id
    json.perk_id @perk_access.perk_id
    json.created_at @perk_access.created_at
  end
end




