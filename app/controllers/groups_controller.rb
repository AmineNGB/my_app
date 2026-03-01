class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:join]

  def join
    if @group.users.include?(current_user)
      redirect_back fallback_location: authenticated_root_path, alert: "Tu es déjà membre de ce groupe."
    else
      @group.users << current_user
      redirect_back fallback_location: authenticated_root_path, notice: "Bienvenue dans le groupe #{@group.name} !"
    end
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end
end
