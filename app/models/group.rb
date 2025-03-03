class Group < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :draws, dependent: :destroy

  def perform_draw
    males = users.where(gender: "H").to_a.shuffle
    females = users.where(gender: "F").to_a.shuffle

    assign_recipients(males)
    assign_recipients(females)
  end

  private

  def assign_recipients(group)
    return if group.size < 2  # Impossible de tirer au sort seul

    shuffled = group.shuffle
    shuffled.each_with_index do |user, index|
      recipient = shuffled[(index + 1) % shuffled.size]  # Attribuer la personne suivante
      Draw.create(user_id: user.id, recipient_id: recipient.id, group_id: self.id)
    end
  end
end
