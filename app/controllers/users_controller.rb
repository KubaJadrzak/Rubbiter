class UsersController < ApplicationController
  def show
    @user = current_user

    @rubits = current_user.root_rubits
    @comments = current_user.comments
    @liked_rubits = current_user.liked_rubits
    
  end
end
