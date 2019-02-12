class Api::BaseController < ApplicationController
  include Pundit

  def authenticate_admin_or_api!
    if params[:access_id] && params[:access_key]
      current_api_employee = @current_user = Api.find_by!(access_id: params[:access_id], access_key: params[:access_key])
      if @current_user != nil && @current_user.active
        return true
      elsif !@current_user&.active
        return render json: {error: I18n.t("devise.failure.inactive")}, status: 422
      else
        return render json: {error: I18n.t("devise.failure.unauthenticated")}, status: 422
      end
    else
      authenticate_api_employee!
    end
  end

  def pundit_user
    @current_user ||= current_api_employee
  end
end
