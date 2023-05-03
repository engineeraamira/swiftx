class User < ApplicationRecord
  include Clearance::User

  enum user_group_id: { Admin: 1, Manager: 2, User: 3}
end
