class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  def authenticate_admin_or_api!
    if headers[:access_id] && headers[:access_key]
      current_user = Api.find_by(access_id: headers[:access_id], access_key: headers[:access_key])
      if current_user&.active
        return true
      elsif !current_user&.active
        return render json: { error: I18n.t('devise.failure.inactive') }, status: 422
      else
        return render json: { error: I18n.t('devise.failure.unauthenticated') }, status: 422
      end
    else
      authenticate_api_v2_admin_employee!
    end
  end
end
