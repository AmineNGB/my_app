class Group < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :draws, dependent: :destroy
end
