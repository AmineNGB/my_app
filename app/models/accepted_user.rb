class AcceptedUser < ApplicationRecord
  belongs_to :user
  belongs_to :accepted_user, class_name: "User"
end
