class User < ApplicationRecord
  include Clearance::User

  has_many :user_jogs
  enum user_group_id: { Admin: 1, Manager: 2, User: 3}
end
