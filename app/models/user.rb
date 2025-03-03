class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar

  belongs_to :group
  has_one :draw, dependent: :destroy
  enum relation_type: { family: 0, by_marriage: 1 }

  validates :gender, presence: true
  validates :relation_type, presence: true
end
