class RubitsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :rubit_not_found
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_rubit, only: [:show, :destroy]


  def index
    # Fetch the paginated root rubits ordered by likes (20 per page) and exclude seen rubits
    if current_user
      seen_rubits = current_user.seen_rubits.select(:rubit_id)
    else
      seen_rubits = Rubit.none  # Returns an empty relation when user is nil
    end
  
    @rubits = Rubit
      .find_root_rubits
      .where.not(id: seen_rubits)
      .left_joins(:likes)
      .group('rubits.id')
      .order('COUNT(likes.id) DESC')
      .page(params[:page])
      .per(20)
  
    @trending_hashtags = Hashtag.trending  # Fetch trending hashtags
    @trending_users = User.trending_users  # Fetch trending users
    @rubit = Rubit.new
  
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show
    @trending_hashtags = Hashtag.trending # Fetch trending hashtags
    @trending_users = User.trending_users # Fetch trending users
  end

  def create
    @rubit = current_user.rubits.new(rubit_params)

    respond_to do |format|
      if @rubit.save
        if @rubit.parent_rubit.present?
          # If parent rubit is present, redirect to the root rubit show page
          format.turbo_stream
        else
          # If parent rubit is not present, it means the creation occured from root page, redirect to root path
          format.turbo_stream
        end
      else
        render :index
      end
    end
  end

  def destroy
    @rubit = Rubit.find(params[:id])
  
    if @rubit.user == current_user || current_user.admin?

      @rubit.destroy
  
      respond_to do |format|
        if @rubit.parent_rubit.present?
          format.turbo_stream
        else
          format.turbo_stream
        end
      end
    else
      redirect_to root_path, alert: 'You are not authorized to delete this rubit.'
    end
  end
  
  def mark_seen
    SeenRubit.find_or_create_by(user: current_user, rubit_id: params[:id])
    head :ok
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
    flash[:alert] = "Rubit not found."
    redirect_to root_path
  end
end
