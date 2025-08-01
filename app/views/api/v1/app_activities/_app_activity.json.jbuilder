json.id app_activity.id
json.app_id app_activity.app_id
json.user_id app_activity.user_id
json.action app_activity.activity_type
json.details do
  json.app_meta app_activity.app_meta
end
json.created_at app_activity.created_at
json.updated_at app_activity.updated_at