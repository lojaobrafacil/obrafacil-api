class Api::BaseController < ApplicationController
  include Pundit
  before_action :pundit_user

  def authenticate_admin_or_api!
    if auth_api_params[:access_id].to_s.empty? && auth_api_params[:access_key].to_s.empty?
      authenticate_api_employee!
    else
      authenticate_admin!
    end
  end

  def authenticate_admin!
    current_api_employee = @current_user = Api.find_by(access_id: params[:access_id], access_key: params[:access_key])
    if @current_user == nil
      return render json: { error: I18n.t("devise.failure.unauthenticated") }, status: 401
    elsif !@current_user.active?
      return render json: { error: I18n.t("devise.failure.inactive") }, status: 401
    else
      return true
    end
  end

  def auth_api_params
    params.permit(:access_id, :access_key)
  end

  def pundit_user
    @current_user ||= current_api_employee
  end
end
