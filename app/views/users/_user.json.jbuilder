json.extract! user, :id, :email, :password, :user_group_id, :status, :deleted, :created_at, :updated_at
json.url user_url(user, format: :json)
