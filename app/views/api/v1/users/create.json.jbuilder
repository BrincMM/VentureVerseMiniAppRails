json.success true
json.message "User created through google"
json.data do
  json.id @user.id
  json.email @user.email
  json.first_name @user.first_name
  json.last_name @user.last_name
  json.google_id @user.google_id
end 