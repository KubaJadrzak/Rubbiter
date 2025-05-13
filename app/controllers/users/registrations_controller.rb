class Users::RegistrationsController < Devise::RegistrationsController
  # Before Devise's default action runs, permit the username parameter
  before_action :configure_sign_up_params, only: [:create]

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      flash[:notice] = "Account updated successfully."
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?
      respond_with resource, location: after_update_path_for(resource)
    else
      flash[:alert] = resource.errors.full_messages.join(", ")
      redirect_to edit_user_registration_path
    end
  end

  private

  # Permit the username field along with email and password
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end

  def after_update_path_for(resource)
    account_path
  end
end
