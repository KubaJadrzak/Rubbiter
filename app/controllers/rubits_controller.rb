class RubitsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_rubit, only: [:show, :destroy]

  def index
    # Fetch the paginated root rubits in random order (20 per page)
    @rubits = Rubit.find_root_rubits.order('RANDOM()').page(params[:page]).per(20)
  
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
          flash.now[:notice] = 'Rubit added successfully!'
          format.turbo_stream
          format.html { redirect_to rubit_path(@rubit) }
        else
          # If parent rubit is not present, it means the creation occured from root page, redirect to root path
          flash.now[:notice] = 'Rubit created successfully!'
          format.turbo_stream
          format.html { redirect_to root_path }
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
