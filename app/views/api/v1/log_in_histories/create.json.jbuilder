json.success true
json.message 'Login history created successfully'
json.data do
  json.log_in_history do
    json.partial! 'log_in_history', log_in_history: @log_in_history
  end
end