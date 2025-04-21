class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_rubit

  def create
    unless @rubit.liked_by_users.include?(current_user)
      @rubit.likes.create(user: current_user)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("rubit_#{@rubit.id}_like_section", partial: "likes/like_section", locals: { rubit: @rubit })
        end
        format.html { redirect_to root_path, notice: "Rubit liked!" }
      end
    end
  end

  def destroy
    like = @rubit.likes.find(params[:id])
    like&.destroy
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("rubit_#{@rubit.id}_like_section", partial: "likes/like_section", locals: { rubit: @rubit })
      end
      format.html { redirect_to root_path, notice: "Rubit unliked!" }
    end
  end

  private

  def set_rubit
    @rubit = Rubit.find(params[:rubit_id])
  end
end
