class Partner::BaseController < ApplicationController
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:federal_registration, :password, :password_confirmation])
  end
end
