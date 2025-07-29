json.success true
json.message "User created successfully"
json.data do
  json.id @user.id
  json.email @user.email
  json.google_id @user.google_id
  json.first_name @user.first_name
  json.last_name @user.last_name
  json.country @user.country
  json.age_consent @user.age_consent
  json.avatar @user.avatar
  json.nick_name @user.nick_name
  json.linkedIn @user.linkedIn
  json.twitter @user.twitter
  json.monthly_credit_balance @user.monthly_credit_balance.to_f
  json.top_up_credit_balance @user.top_up_credit_balance.to_f
  json.tier_id @user.tier_id
  json.created_at @user.created_at
  json.updated_at @user.updated_at
end 