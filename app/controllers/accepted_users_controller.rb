class AcceptedUsersController < ApplicationController
  before_action :authenticate_user!

  def edit
    @users = User.where.not(id: current_user.id)
             .where(group_id: current_user.group_id)
             .where.not(gender: current_user.gender) # Exclure le même genre
    @accepted_user_ids = current_user.accepted_people.pluck(:id)
  end

  def update
    if current_user.update(accepted_user_ids: params[:accepted_user_ids])
      redirect_to root_path, notice: "Liste mise à jour avec succès !"
    else
      flash[:alert] = "Erreur lors de la mise à jour."
      render :edit
    end
  end
end
