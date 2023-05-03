class UserJog < ApplicationRecord
  belongs_to :user

  belongs_to :createdby, class_name: "User", foreign_key: "created_by"

end
