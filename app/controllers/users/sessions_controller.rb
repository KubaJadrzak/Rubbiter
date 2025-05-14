class Users::SessionsController < ApplicationController
  def dev_login
    user = User.first
    sign_in(user)
    redirect_to account_path, notice: "Logged in as #{user.email}"
  end
end
