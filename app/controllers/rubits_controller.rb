class RubitsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def index
    @rubits = Rubit.where(parent_rubit_id: nil).order(created_at: :desc)  # Only posts (no parent)
    @rubit = Rubit.new
  end

  def show
    @rubit = Rubit.find(params[:id])
    @comments = @rubit.child_rubits.order(created_at: :desc)  # Comments are child rubits of this rubit
    @comment = Rubit.new
  end

  def create
    if params[:rubit][:parent_rubit_id].present?
      # If parent_rubit_id is present, create a comment (child rubit)
      @rubit = current_user.rubits.new(rubit_params.merge(parent_rubit_id: params[:rubit][:parent_rubit_id]))
    else
      # If no parent_rubit_id, create a regular rubit (post)
      @rubit = current_user.rubits.new(rubit_params)
    end
  
    if @rubit.save
      redirect_to root_path, notice: 'Rubit added successfully!'
    else
      render :index
    end
  end

  private

  def rubit_params
    params.require(:rubit).permit(:content, :rubit_id)
  end
end
