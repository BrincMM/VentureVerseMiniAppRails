json.success true
json.message 'Profile updated successfully'
json.data do
  json.developer do
    json.partial! 'api/v1/developers/shared/developer', developer: @developer
  end
end


