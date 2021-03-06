class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_last_seen_at, if: proc { manager_signed_in? }

  def current_user
    current_manager
  end

  def after_sign_in_path_for(resource)
    dashboard_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  private

  def set_last_seen_at
    current_manager.update_attribute(:last_seen_at, Time.current)
  end
end
