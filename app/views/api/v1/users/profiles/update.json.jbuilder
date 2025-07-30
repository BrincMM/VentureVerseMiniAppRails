json.status 'success'
json.message 'Profile updated successfully'
json.data do
  json.user do
    json.partial! 'api/v1/users/shared/user', user: @user
  end
end