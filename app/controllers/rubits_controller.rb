class RubitsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_rubit, only: [:show, :destroy]

  def index
    @rubits = Rubit.find_root_rubits
                    .left_joins(:likes)  # Use LEFT JOIN to include rubits with no likes
                    .where('likes.created_at >= ? OR likes.created_at IS NULL', 24.hours.ago)  # Include rubits with no likes
                    .group('rubits.id')
                    .order('COUNT(likes.id) DESC')
    @trending_hashtags = Hashtag.trending # Fetch trending hashtags
    @trending_users = User.trending_users # Fetch trending users
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
