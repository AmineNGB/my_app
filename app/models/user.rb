class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar
  has_many :accepted_users, dependent: :destroy
  has_many :accepted_people, through: :accepted_users, source: :accepted_user

  belongs_to :group
  has_one :draw, dependent: :destroy
  enum relation_type: { family: 0, by_marriage: 1 }

  validates :gender, presence: true
  validates :relation_type, presence: true

  # Permet d'ajouter des personnes acceptées via un tableau d'IDs
  def accepted_user_ids=(ids)
    self.accepted_users.destroy_all
    ids.reject(&:blank?).each do |accepted_id|
      self.accepted_users.create(accepted_user_id: accepted_id)
    end
  end
end
