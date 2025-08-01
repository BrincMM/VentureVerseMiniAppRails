json.success true
json.message 'Credit spent record created successfully'
json.data do
  json.credits @credit_spent.credits.to_f
  json.credit_spent_record do
    json.id @credit_spent.id
    json.user_id @credit_spent.user_id
    json.cost_in_usd @credit_spent.cost_in_usd.to_f
    json.credits @credit_spent.credits.to_f
    json.spend_type @credit_spent.spend_type
    json.timestamp @credit_spent.timestamp
    json.created_at @credit_spent.created_at
    json.updated_at @credit_spent.updated_at
  end
  json.user do
    json.id @credit_spent.user.id
    json.monthly_credit_balance @credit_spent.user.monthly_credit_balance.to_f
    json.topup_credit_balance @credit_spent.user.topup_credit_balance.to_f
  end
end
