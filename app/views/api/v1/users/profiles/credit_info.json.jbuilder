json.success true
json.message 'Credit info retrieved successfully'
json.data do
  json.user do
    json.tier do
      json.id @user.tier.id
      json.name @user.tier.name
      json.monthly_credit @user.tier.monthly_credit
    end
    json.monthly_credit_balance @user.monthly_credit_balance
    json.topup_credit_balance @user.topup_credit_balance
    json.remaining_ratio @user.remaining_credit_ratio
  end
end