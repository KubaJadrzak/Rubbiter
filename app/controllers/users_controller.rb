class UsersController < ApplicationController
  def show
    @user = current_user
    
    # Determine which rubits to show based on the view parameter
    if params[:view] == 'comments'
      @rubits = @user.comments.order(created_at: :desc) # Comments only
    else
      @rubits = @user.root_rubits.order(created_at: :desc) # Root rubits only
    end
  end
end
