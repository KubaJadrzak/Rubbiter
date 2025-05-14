class RubitsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :rubit_not_found
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_rubit, only: [:show, :destroy]

  def index
    @rubits = Rubit
      .root_rubits
      .left_joins(:likes)
      .group("rubits.id")
      .order("COUNT(likes.id) DESC")
      .page(params[:page])
      .per(20)

    @trending_hashtags = Hashtag.trending
    @trending_users = User.trending_users
    @rubit = Rubit.new

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show
    @trending_hashtags = Hashtag.trending
    @trending_users = User.trending_users
  end

  def create
    @rubit = current_user.rubits.new(rubit_params)

    respond_to do |format|
      if @rubit.save
        flash.now[:notice] = "Rubit created successfully."
        format.turbo_stream
      else
        redirect_to root_path, flash[:alert] = "Failed to create Rubit"
      end
    end
  end

  def destroy
    @rubit = current_user.rubits.find(params[:id])

    @rubit.destroy
    flash.now[:notice] = "Rubit deleted successfully."

    respond_to do |format|
      format.turbo_stream
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "You are not authorized to delete this rubit."
  end

  private

  def set_rubit
    @rubit = Rubit.find(params[:id])
  end

  def rubit_params
    params.require(:rubit).permit(:content, :parent_rubit_id)
  end

  def find_root_rubit(rubit)
    while rubit.parent_rubit.present?
      rubit = rubit.parent_rubit
    end
    rubit
  end

  def rubit_not_found
    redirect_to root_path, flash[:alert] = "Rubit not found."
  end
end
