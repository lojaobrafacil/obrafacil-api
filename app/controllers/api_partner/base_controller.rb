class ApiPartner::BaseController < ApplicationController
  before_action :configure_permitted_parameters, if: :devise_controller?

  def contact
    begin
      EmployeeMailer.new_contact(contact_params.as_json.symbolize_keys).deliver_now
      render json: { success: "Recebemos seu contato, entraremos em contato o mais rápido possível." }, status: 201
    rescue
      head 422
    end
  end

  def contact_params
    params.permit(:name, :email, :subject, :phone, :message)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:federal_registration, :password, :password_confirmation])
  end
end
