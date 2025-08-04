json.success true
json.message 'Plan changed successfully'
json.data do
  json.user do
    json.partial! 'api/v1/users/shared/user', user: @user
    json.stripe_info do
      json.partial! 'api/v1/users/shared/stripe_info', stripe_info: @user.stripe_info
    end
  end
end