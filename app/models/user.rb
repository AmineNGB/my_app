class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  has_one_attached :avatar
  has_many :exclusions, dependent: :destroy
  has_many :excluded_users, through: :exclusions, source: :excluded_user

  has_many :group_memberships, dependent: :destroy
  has_many :groups, through: :group_memberships

  has_many :reverse_exclusions, class_name: "Exclusion", foreign_key: "excluded_user_id", dependent: :destroy
  has_many :excluded_by, through: :reverse_exclusions, source: :user

  has_many :draws, dependent: :destroy

  enum relation_type: { family: 0, by_marriage: 1 }

  validates :username, presence: true, uniqueness: true
  validates :avatar, presence: true

  validates :gender, presence: true
  validates :relation_type, presence: true

  def email_required?
    false
  end

  def email_changed?
    false
  end
end
