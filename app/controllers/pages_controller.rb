class PagesController < ApplicationController
  def home
    @groups = Group.includes(:users).all
    @draws = current_user.draws.includes(:group).order("groups.id")
  end
end
