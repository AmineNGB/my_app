class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:join, :leave]

  def join
    if @group.users.include?(current_user)
      redirect_back fallback_location: authenticated_root_path, alert: "Tu es déjà membre de ce groupe."
    else
      @group.users << current_user
      redirect_back fallback_location: authenticated_root_path, notice: "Bienvenue dans le groupe #{@group.name} !"
    end
  end

  def leave
    if @group.users.include?(current_user)
      @group.users.delete(current_user)
      redirect_back fallback_location: authenticated_root_path, notice: "Tu as quitté le groupe #{@group.name}."
    else
      redirect_back fallback_location: authenticated_root_path, alert: "Tu ne fais pas partie de ce groupe."
    end
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end
end
