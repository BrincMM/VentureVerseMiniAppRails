json.success true
json.message 'Perk access revoked successfully'
json.data do
  json.perk_access do
    json.id @perk_access.id
    json.user_id @perk_access.user_id
    json.perk_id @perk_access.perk_id
  end
end



