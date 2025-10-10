json.success true
json.message "Password verified successfully"
json.data do
  json.developer do
    json.partial! 'api/v1/developers/shared/developer', developer: @developer
  end
end



