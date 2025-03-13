class ExclusionsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @users = User.where.not(id: current_user.id)
                 .where(group_id: current_user.group_id)
    @exclusion_ids = current_user.excluded_users.pluck(:id)
  end

  def update
    # Vérifie si exclusion_ids est présent, sinon initialise un tableau vide
    new_excluded_users = User.where(id: params[:exclusion_ids] || [])

    if current_user.excluded_users = new_excluded_users
      redirect_to root_path, notice: "Liste mise à jour avec succès !"
    else
      flash[:alert] = "Erreur lors de la mise à jour."
      render :edit
    end
  end
end
