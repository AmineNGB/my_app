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

  validates :gender, presence: true
  validates :relation_type, presence: true
  validates :avatar, presence: { message: "Veuillez ajouter une photo de profil" }

  def email_required?
    false
  end

  def email_changed?
    false
  end


  # dit à Devise de chercher par username pour recoverable
  def self.send_reset_password_instructions(attributes={})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    recoverable.send_reset_password_instructions_internal if recoverable.persisted?
    recoverable
  end

  protected

  # méthode interne pour générer token sans email
  def send_reset_password_instructions_internal
    token = set_reset_password_token
    # on ne tente pas d’envoyer d’email
    token
  end
end
