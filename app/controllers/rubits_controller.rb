class RubitsController < ApplicationController
    before_action :authenticate_user!, only: [:new, :create]
  
    def index
      @rubits = Rubit.all.order(created_at: :desc)
      @rubit = Rubit.new
    end
  
    def new
      @rubit = Rubit.new
    end
  
    def create
      @rubit = current_user.rubits.new(rubit_params)
  
      if @rubit.save
        redirect_to root_path, notice: 'Rubit created successfully!' 
      else
        render :index
      end
    end
  
    private
  
    def rubit_params
      params.require(:rubit).permit(:content) 
    end
  end
  