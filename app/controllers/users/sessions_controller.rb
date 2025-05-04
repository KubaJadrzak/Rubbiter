class Users::SessionsController < ApplicationController
  def dev_login
    user = User.first # Or create/find a specific dev user
    sign_in(user)     # Devise helper
    redirect_to profile_path, notice: "Logged in as #{user.email}"
  end
end
