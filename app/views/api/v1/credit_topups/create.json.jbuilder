json.success true
json.message 'Credit topup record created successfully'
json.data do
  json.credits @credit_topup.credits.to_f
  json.credit_topup_record do
    json.id @credit_topup.id
    json.user_id @credit_topup.user_id
    json.credits @credit_topup.credits.to_f
    json.timestamp @credit_topup.timestamp
    json.created_at @credit_topup.created_at
    json.updated_at @credit_topup.updated_at
  end
  json.user do
    json.id @credit_topup.user.id
    json.monthly_credit_balance @credit_topup.user.monthly_credit_balance.to_f
    json.topup_credit_balance @credit_topup.user.topup_credit_balance.to_f
    json.remaining_credit_ratio @credit_topup.user.remaining_credit_ratio
  end
end