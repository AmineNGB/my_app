class DrawService
  def initialize(group)
    @group = group
    @users = group.users.shuffle
  end

  def perform_draw
    max_attempts = 50
    attempt = 0

    begin
      attempt += 1
      draws = {}
      available_recipients = @users.dup.shuffle
      taken_recipients = Set.new # Liste des personnes déjà tirées (sauf si inversion)

      # 🎯 Trier les utilisateurs par contraintes (priorité à ceux qui ont des contraintes)
      sorted_users = @users.sort_by { |user| constraint_score(user) }.reverse

      sorted_users.each do |user|
        recipient = find_valid_recipient(user, available_recipients, taken_recipients, draws)

        if recipient.nil?
          raise "❌ Tirage bloqué pour #{user.name}, on recommence !"
        end

        draws[user] = recipient
        taken_recipients.add(recipient) unless draws[recipient] == user # ✅ Autoriser l'inversion

        available_recipients.delete(recipient)
      end

      # 🔄 Enregistrement des tirages
      Draw.insert_all(draws.map { |user, recipient| { user_id: user.id, recipient_id: recipient.id, group_id: @group.id } })

    rescue => e
      retry if attempt < max_attempts
      raise "❌ Impossible de générer un tirage après #{max_attempts} essais : #{e.message}"
    end
  end

  private

  # 🔍 Trouver un destinataire valide pour un utilisateur
  def find_valid_recipient(user, recipients, taken_recipients, draws)
    valid_candidates = recipients.select do |r|
      r != user && # 🚫 Ne pas se tirer soi-même
      (r.gender == user.gender || user.accepted_people.include?(r)) && # ✅ Même genre ou accepted_people
      (!taken_recipients.include?(r) || draws[r] == user) # ✅ Vérifie qu'il n'a pas déjà été tiré, sauf si c'est une paire inversée
    end

    valid_candidates.sample # On prend un au hasard parmi les valides
  end

  # ✅ Score pour prioriser les utilisateurs ayant des contraintes strictes
  def constraint_score(user)
    score = 0
    score += 1 if user.accepted_people.any? # 🎯 A une liste de personnes acceptées
    score
  end
end
