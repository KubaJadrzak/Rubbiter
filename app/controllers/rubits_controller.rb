class RubitsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_rubit, only: [:show, :destroy]

  def index
    @rubits = Rubit.find_root_rubits.order(created_at: :desc)
    @trending_hashtags = Hashtag.trending # Fetch trending hashtags
    @trending_users = User.trending_users # Fetch trending users
    @rubit = Rubit.new
  end

  def show
    # The rubit is already set by the before_action
  end

  def create
    if params[:rubit][:parent_rubit_id].present?
      @rubit = current_user.rubits.new(rubit_params.merge(parent_rubit_id: params[:rubit][:parent_rubit_id]))
    else
      @rubit = current_user.rubits.new(rubit_params)
    end
  
    if @rubit.save
      if @rubit.parent_rubit_id.present?
        root_rubit = find_root_rubit(@rubit)
        redirect_to rubit_path(root_rubit), notice: 'Comment added successfully!'
      else
        redirect_to root_path, notice: 'Rubit created successfully!'
      end
    else
      render :index
    end
  end

  def destroy
    @rubit = Rubit.find(params[:id])
  
    if @rubit.user == current_user || current_user.admin?
  
      # Now delete the rubit
      @rubit.destroy
  
      # Respond with Turbo to update the page dynamically
      respond_to do |format|
        if @rubit.parent_rubit_id.present?
          # It's a child rubit, so remove it from the page using Turbo
          format.turbo_stream do
            render turbo_stream: turbo_stream.remove("rubit_#{@rubit.id}")
          end
          format.html { redirect_to rubit_path(find_root_rubit(@rubit)), notice: 'Comment has been deleted successfully!' }
        else
          # It's a root rubit, so remove it from the page using Turbo
          format.turbo_stream do
            render turbo_stream: turbo_stream.remove("rubit_#{@rubit.id}")
          end
          format.html { redirect_to root_path, notice: 'Rubit has been deleted successfully!' }
        end
      end
    else
      redirect_to root_path, alert: 'You are not authorized to delete this rubit.'
    end
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
end
