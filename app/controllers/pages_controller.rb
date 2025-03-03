class PagesController < ApplicationController
  def home
    @draw = current_user.draw
    @group = current_user.group
  end
end
