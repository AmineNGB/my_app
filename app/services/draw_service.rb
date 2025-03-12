class DrawService
  def initialize(group)
    @group = group
    @users = group.users.shuffle
    @accepted_users = build_accepted_users
  end

  def perform_draw
    max_attempts = 50
    attempt = 0

    begin
      attempt += 1
      draws = {}
      taken = Set.new

      # Trier les utilisateurs selon leurs contraintes (moins de choix en premier)
      sorted_users = @users.sort_by { |user| constraint_score(user) }.reverse

      sorted_users.each do |user|
        recipient = find_valid_recipient(user, draws, taken)

        if recipient.nil?
          raise "❌ Tirage bloqué pour #{user.name}, on recommence !"
        end

        draws[user] = recipient
        taken.add([user.id, recipient.id]) # Ajouter uniquement l'ID du destinataire
      end

      # 🔄 Enregistrement des tirages
      Draw.insert_all(draws.map { |user, recipient| { user_id: user.id, recipient_id: recipient.id, group_id: @group.id } })

    # rescue => e
    #   retry if attempt < max_attempts
    #   raise "❌ Impossible de générer un tirage après #{max_attempts} essais : #{e.message}"
    end
  end

  private

  # 🔍 Récupérer les relations accepted_users
  def build_accepted_users
    accepted_users = Hash.new { |hash, key| hash[key] = [] }

    # Récupérer uniquement les relations des utilisateurs du groupe actuel
    AcceptedUser.where(user_id: @users.map(&:id)).find_each do |relation|
      accepted_users[relation.user_id] << relation.accepted_user_id
    end

    accepted_users
  end


  # 🔍 Trouver un destinataire valide pour un utilisateur
  def find_valid_recipient(user, draws, taken)
    available_recipients = @users  # Enlever ceux déjà tirés
    accepted_users = @accepted_users[user.id].uniq || [] # Récupérer les accepted_users via ID

    valid_candidates = available_recipients.select do |r|
      r.id != user.id && # Ne pas se tirer soi-même
      (!taken.any? { |_, v| v == r.id } || draws[r] == user) && # Vérifier si r.id est déjà pris comme valeur
      (r.gender == user.gender || accepted_users.include?(r.id)) # Même genre OU dans les accepted_users
    end

    valid_candidates.sample # Tirage aléatoire parmi les valides
  end

  #   valid_candidates = available_recipients.select do |r|
  #     r.id != user.id && # Ne pas se tirer soi-même
  #     raise
  #     (!draws.value?(r)) && # Vérifier si r.id n'est pas déjà un destinataire
  #     (!taken.any? { |_, v| v == r.id }) && # Vérifier si r.id n'est pas déjà pris
  #     (r.gender == user.gender || accepted_users.include?(r.id)) # Même genre OU dans les accepted_users
  #   end

  #   valid_candidates.sample # Tirage aléatoire parmi les valides
  # end

  # ✅ Score basé sur les contraintes
  def constraint_score(user)
    accepted_users = @accepted_users[user.id] || []
    score = accepted_users.count # Prioriser ceux qui ont moins de choix
    score
  end
end
