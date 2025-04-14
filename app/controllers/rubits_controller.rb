class RubitsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_rubit, only: [:show, :destroy]

  def index
    # Fetch rubits in random order and convert to an array
    @rubits = Rubit.find_root_rubits.order('RANDOM()').to_a  # Convert to an array
  
    # If the user is logged in, find the current user's most recent rubit
    if current_user
      current_user_rubit = Rubit.where(user: current_user).order(created_at: :desc).first
  
      # Place the current user's most recent rubit at the top of the list
      @rubits.unshift(current_user_rubit) if current_user_rubit
    end
  
    @trending_hashtags = Hashtag.trending  # Fetch trending hashtags
    @trending_users = User.trending_users  # Fetch trending users
    @rubit = Rubit.new
  end

  def show
    @trending_hashtags = Hashtag.trending # Fetch trending hashtags
    @trending_users = User.trending_users # Fetch trending users
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
        redirect_to rubit_path(root_rubit), notice: 'Rubit added successfully!'
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
  
      @rubit.destroy
  
      respond_to do |format|
        if @rubit.parent_rubit_id.present?
          flash.now[:notice] = 'Rubit has been deleted successfully!'
          format.turbo_stream
          format.html { redirect_to rubit_path(find_root_rubit(@rubit)) }
        else
          flash.now[:notice] = 'Rubit has been deleted successfully!'
          format.turbo_stream
          format.html { redirect_to root_path } 
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
