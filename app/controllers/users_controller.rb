class UsersController < ApplicationController
  def show
    @user = current_user

    case params[:view]
    when 'comments'
      @rubits = @user.comments.active.order(created_at: :desc)
    when 'liked'
      @rubits = @user.liked_rubits.active.order(created_at: :desc)
    else # 'rubits' or default
      @rubits = @user.root_rubits.active.order(created_at: :desc)
    end
  end
end
