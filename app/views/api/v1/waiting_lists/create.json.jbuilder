json.success true
json.message 'Successfully subscribed to waiting list'
json.data do
  json.email @waiting_list.email
  json.subscribe_type @waiting_list.subscribe_type
  json.name @waiting_list.name
  json.first_name @waiting_list.first_name
  json.last_name @waiting_list.last_name
end
