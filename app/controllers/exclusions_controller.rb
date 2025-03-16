class ExclusionsController < ApplicationController
  before_action :authenticate_user!

  def edit
    # Récupère les membres du même groupe que l'utilisateur
    @users = User.joins(:group_memberships)
                 .where(group_memberships: { group_id: current_user.group_ids })
                 .where.not(id: current_user.id)
                 .order(:id).distinct

    @exclusion_ids = current_user.excluded_users.pluck(:id)
  end

  def update
    max_exclusions = User.joins(:group_memberships)
                  .where(group_memberships: { group_id: current_user.group_ids })
                  .where.not(id: current_user.id)
                  .where(gender: opposite_gender(current_user.gender)).distinct.count

    # Vérifier avant d'appliquer la requête SQL
    if (params[:exclusion_ids] || []).count > max_exclusions
      # flash.now[:alert] = "Vous ne pouvez exclure que #{max_exclusions} utilisateurs au maximum."

      # Réinitialisation des variables pour éviter un bug avec `render :edit`
      @users = User.joins(:group_memberships)
                  .where(group_memberships: { group_id: current_user.group_ids })
                  .where.not(id: current_user.id)
                  .order(:id).distinct
      @exclusion_ids = current_user.excluded_users.pluck(:id)

      flash[:alert] = "Vous ne pouvez exclure que #{max_exclusions} utilisateurs au maximum."
      return redirect_to edit_exclusions_path
    end

    new_excluded_users = User.where(id: params[:exclusion_ids] || []).limit(max_exclusions)

    if current_user.update(excluded_users: new_excluded_users)
      redirect_to root_path, notice: "Liste mise à jour avec succès !"
    else
      flash[:alert] = "Erreur lors de la mise à jour."

      # Recharger les variables avant render
      @users = User.joins(:group_memberships)
                  .where(group_memberships: { group_id: current_user.group_ids })
                  .where.not(id: current_user.id)
                  .order(:id).distinct
      @exclusion_ids = current_user.excluded_users.pluck(:id)

      render :edit
    end
  end



  private

  def opposite_gender(gender)
    gender == "H" ? "F" : "H"
  end
end
