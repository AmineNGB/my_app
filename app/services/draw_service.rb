class DrawService
  def initialize(group)
    @group = group
    @users = group.users.shuffle
    @exclusions = build_exclusions
  end

  def perform_draw
    max_attempts = 50
    attempt = 0

    begin
      attempt += 1
      draws = {}
      taken = Set.new

      # Trier les utilisateurs par contraintes (ceux avec le moins de choix passent en premier)
      sorted_users = @users.sort_by { |user| possible_recipients(user).size }

      sorted_users.each do |user|
        recipient = find_valid_recipient(user, draws, taken)

        if recipient.nil?
          raise "❌ Tirage bloqué pour #{user.username}, on recommence !"
        end

        draws[user] = recipient
        taken.add(recipient.id)
      end

      # Enregistrement des tirages
      Draw.insert_all(draws.map { |user, recipient| { user_id: user.id, recipient_id: recipient.id, group_id: @group.id } })

    rescue => e
      retry if attempt < max_attempts
      raise "❌ Impossible de générer un tirage après #{max_attempts} essais : #{e.message}"
    end
  end

  private

  # 🔍 Construction des exclusions (hash user_id => [exclusions])
  def build_exclusions
    exclusions = Hash.new { |hash, key| hash[key] = [] }

    Exclusion.where(user_id: @users.map(&:id)).find_each do |relation|
      exclusions[relation.user_id] << relation.excluded_user_id
      exclusions[relation.excluded_user_id] << relation.user_id # Réciprocité de l'exclusion
    end

    exclusions
  end

  # 🔍 Trouver un destinataire valide pour un utilisateur
  def find_valid_recipient(user, draws, taken)
    candidates = possible_recipients(user).reject { |r| taken.include?(r.id) }

    # 🛑 Guard clause : si aucun choix possible, on stoppe ici
    return nil if candidates.empty?

    candidates.sample # Tirage aléatoire parmi les valides
  end

  # 📌 Retourne les personnes que `user` peut tirer au sort
  def possible_recipients(user)
    @users.reject do |r|
      r.id == user.id ||                # Ne pas se tirer soi-même
      @exclusions[user.id].include?(r.id) # Vérifier les exclusions
    end
  end
end
