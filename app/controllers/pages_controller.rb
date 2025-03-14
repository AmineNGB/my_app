class PagesController < ApplicationController
  def home
    @draws = current_user.draws.includes(:group).order("groups.id")
  end
end
