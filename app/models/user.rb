class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar
  has_many :exclusions, dependent: :destroy
  has_many :excluded_users, through: :exclusions, source: :excluded_user

   # Pour récupérer les utilisateurs qui ont exclu ce user
  has_many :reverse_exclusions, class_name: "Exclusion", foreign_key: "excluded_user_id", dependent: :destroy
  has_many :excluded_by, through: :reverse_exclusions, source: :user

  belongs_to :group
  has_one :draw, dependent: :destroy
  enum relation_type: { family: 0, by_marriage: 1 }

  validates :gender, presence: true
  validates :relation_type, presence: true

end
