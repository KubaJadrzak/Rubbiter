class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:account]

  def account
    @user = current_user
    @rubits = current_user.root_rubits.order(created_at: :desc)
    @comments = current_user.comments.order(created_at: :desc)
    @liked_rubits = Rubit.joins(:likes)
                         .where(likes: { user_id: current_user.id })
                         .order("likes.created_at DESC")
    @orders = current_user.orders.order(created_at: :desc)
  end
end
