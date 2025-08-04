json.success true
json.message 'Login histories retrieved successfully'
json.data do
  json.log_in_histories @log_in_histories do |log_in_history|
    json.partial! 'log_in_history', log_in_history: log_in_history
  end
  json.has_next @log_in_histories.next_page.present?
  json.total_count @total_count
  json.total_pages @log_in_histories.total_pages
  json.per_page @log_in_histories.limit_value
  json.current_page @log_in_histories.current_page
end