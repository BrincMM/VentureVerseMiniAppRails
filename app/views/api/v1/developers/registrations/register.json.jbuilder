json.success true
json.message "Developer created successfully"
json.data do
  json.developer do
    json.partial! 'api/v1/developers/shared/developer', developer: @developer
  end
end


