class DrawService
  def initialize(group)
    @group = group
    @users = group.users.shuffle
  end

  def perform_draw
    max_attempts = 5
    attempt = 0

    begin
      attempt += 1
      available_recipients = @users.dup.shuffle  # Liste mélangée des destinataires

      draws = []
      existing_pairs = Set.new # Stocke les paires déjà faites sous forme [A, B]

      @users.each do |user|
        possible_recipients = available_recipients.reject do |recipient|
          recipient == user || # 🚫 Ne pas se tirer soi-même
          existing_pairs.include?([recipient.id, user.id]) || # 🚫 Éviter une paire inversée
          (user.only_same_gender? && recipient.gender != user.gender) || # 🚹🚺 Respecter le genre
          (user.by_marriage? && recipient.by_marriage?) # 💍 Ne pas faire tirer entre mariés
        end

        if possible_recipients.empty?
          raise "❌ Tirage bloqué pour #{user.name}, on recommence !"
        end

        recipient = possible_recipients.sample

        draws << { user_id: user.id, recipient_id: recipient.id, group_id: @group.id }
        existing_pairs.add([user.id, recipient.id]) # ✅ Ajouter la paire (A → B)
        available_recipients.delete(recipient) # ❌ Retirer le destinataire de la liste
      end

      # ✅ Sauvegarde des tirages si tout s'est bien passé
      Draw.insert_all(draws)

    rescue => e
      retry if attempt < max_attempts
      raise "❌ Impossible de générer un tirage après #{max_attempts} essais : #{e.message}"
    end
  end
end
