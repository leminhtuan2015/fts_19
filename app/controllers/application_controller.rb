class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include UsersHelper
  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit :name, :email,
      :password, :password_confirmation, :remember_me, :avatar}
    devise_parameter_sanitizer.for(:account_update) {|u| u.permit :name, 
      :email, :password, :password_confirmation, :current_password, :avatar}
  end
end