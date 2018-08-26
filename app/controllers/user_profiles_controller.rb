class UserProfilesController < ApplicationController
  before_action :require_logged_in

  def show
    @user = current_user
  end

  def update
    @user = current_user
  end

end
