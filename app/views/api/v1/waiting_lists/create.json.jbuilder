json.success true
json.message 'Successfully subscribed to waiting list'
json.data do
  json.email @waiting_list.email
  json.subscribe_type @waiting_list.subscribe_type
end
