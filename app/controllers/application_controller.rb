class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  def authenticate_admin_or_api!
    if params[:access_id] && params[:access_key]
      @current_user = Api.find_by(access_id: params[:access_id], access_key: params[:access_key])
      if @current_user&.active
        return true
      elsif !@current_user&.active
        return render json: { error: I18n.t('devise.failure.inactive') }, status: 422
      else
        return render json: { error: I18n.t('devise.failure.unauthenticated') }, status: 422
      end
    else
      authenticate_api_employee!
    end
  end

  def version
    render(json: {
      current: 200,
      minimum: 200,
      title: 'HUBCO API V2'
    })
  end
end
