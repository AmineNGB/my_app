class Admin::GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!

  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
    @draws = @group.draws.includes(:user, :recipient)
  end

  def perform_draw
    @group = Group.find(params[:id])
    @group.draws.destroy_all # Supprime les anciens tirages
    DrawService.new(@group).perform_draw
    redirect_to admin_group_path(@group), notice: "Tirage effectué avec succès !"
  end

  private

  def ensure_admin!
    redirect_to root_path, alert: "Accès refusé" unless current_user.name.match('Amine Neghbel')
  end
end
