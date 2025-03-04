class Draw < ApplicationRecord
  belongs_to :user
  belongs_to :recipient, class_name: "User"
  default_scope { order(:user_id) }
end
