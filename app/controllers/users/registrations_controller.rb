class Users::RegistrationsController < Devise::RegistrationsController
  # Before Devise's default action runs, permit the username parameter
  before_action :configure_sign_up_params, only: [:create]

  private

  # Permit the username field along with email and password
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
end
