class Exclusion < ApplicationRecord
  belongs_to :user
  belongs_to :excluded_user, class_name: "User"

  # Empêcher les exclusions en double
  validates :excluded_user_id, uniqueness: { scope: :user_id }
end
