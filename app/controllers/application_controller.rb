class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_locale

	rescue_from CanCan::AccessDenied do |exception|
  	flash[:warning] = exception.message
  	redirect_to root_path
	end

protected

	def configure_permitted_parameters
	  devise_parameter_sanitizer.for(:sign_up) << :name
	  devise_parameter_sanitizer.for(:sign_up) << :role
    devise_parameter_sanitizer.for(:sign_up) << :theme
    devise_parameter_sanitizer.for(:sign_up) << :menu_orientation
	  devise_parameter_sanitizer.for(:account_update) << :name
	  devise_parameter_sanitizer.for(:account_update) << :role
    devise_parameter_sanitizer.for(:account_update) << :theme
    devise_parameter_sanitizer.for(:account_update) << :menu_orientation
	end

private

  def set_locale
    I18n.locale = params[:locale] if params[:locale].present?
  end

  def default_url_options(options = {})
    { locale: I18n.locale }
  end
end
