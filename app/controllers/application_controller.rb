class ApplicationController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? }
  

  
  def authorize_as_admin
    return 'unauthorized' unless current_user.is_admin?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])  
  end
end
