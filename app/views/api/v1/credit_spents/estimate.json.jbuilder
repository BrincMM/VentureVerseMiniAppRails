json.success true
json.message 'Credit amount calculated successfully'
json.data do
  json.credit_required @credit_required
  json.user do
    json.id @user.id
    json.monthly_credit_balance @user.monthly_credit_balance.to_f
    json.topup_credit_balance @user.topup_credit_balance.to_f
  end
end
