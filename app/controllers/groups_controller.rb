class GroupsController < ApplicationController
  def index
    @groups = Group.all
    @users = User.all
  end

  def show
    @group = Group.find(params[:id])
    @users = @group.users
  end

  def draw
    group = Group.find(params[:id])
    group.perform_draw
    redirect_to group_path(group), notice: "Tirage au sort effectué !"
  end
end
