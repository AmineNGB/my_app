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
                 .where(group_memberships: { group_id: current_user.group_ids }).where.not(id: current_user.id)
                 .where(gender: opposite_gender(current_user.gender)).distinct.count # Define your max limit

    new_excluded_users = User.where(id: params[:exclusion_ids] || []).limit(max_exclusions)
    if new_excluded_users.count > max_exclusions
      flash[:alert] = "Vous ne pouvez exclure que #{max_exclusions} utilisateurs au maximum."
      return render :edit
    end
    # Mise à jour des exclusions avec `update`
    if current_user.update(excluded_users: new_excluded_users)
      redirect_to root_path, notice: "Liste mise à jour avec succès !"
    else
      flash[:alert] = "Erreur lors de la mise à jour."
      render :edit
    end
  end

  private

  def opposite_gender(gender)
    gender == "H" ? "F" : "H"
  end
end
