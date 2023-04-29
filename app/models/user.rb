class User < ApplicationRecord
  include Clearance::User

  enum usergroup: { Admin: 1, Manager: 2, User: 3}
end
