json.extract! user_jog, :id, :user_id, :jogging_date, :jogging_time, :distance, :created_by, :deleted, :deleted_by, :deleted_at, :created_at, :updated_at
json.url user_jog_url(user_jog, format: :json)
