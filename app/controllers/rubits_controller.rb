class RubitsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_rubit, only: [:show, :destroy]

  def index
    @rubits = Rubit.find_root_rubits.order(created_at: :desc)
    @trending_hashtags = Hashtag.trending # Fetch trending hashtags
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
      if @rubit.parent_rubit_id.present?
        # It's a comment (child rubit), mark it as removed
        @rubit.update(status: :removed, content: 'This comment has been removed by the user.')
        
        # Respond with turbo_stream to replace the content of the child rubit
        respond_to do |format|
          format.turbo_stream { 
            render turbo_stream: turbo_stream.replace("rubit_#{@rubit.id}", partial: "rubits/child_rubit", locals: { rubit: @rubit })
          }
          format.html { redirect_to rubit_path(find_root_rubit(@rubit)), notice: 'Comment has been removed successfully!' }
        end
      else
        # It's a root rubit, mark it as removed
        @rubit.update(status: :removed, content: 'This rubit has been removed by the user.')
        
        # Respond with turbo_stream to replace the content of the rubit
        respond_to do |format|
          format.turbo_stream { 
            render turbo_stream: turbo_stream.replace("rubit_#{@rubit.id}", partial: "rubits/rubit", locals: { rubit: @rubit })
          }
          format.html { redirect_to root_path, notice: 'Rubit has been removed successfully!' }
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
