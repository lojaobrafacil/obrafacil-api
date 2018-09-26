class Api::V2::Admin::UsersController < Api::V2::Admin::BaseController

  def reset_password
    authorize [:admin, User]
    user = User.where(federal_registration: params[:federal_registration]).first
    if user && user.reset_password(params[:password], params[:password_confirmation])
      render json: { status: "Ok" }, status: 201
    else 
      render json: { errors: {error: "usuario não existe ou password_confirmation incorreto"} }, status: 422
    end
  end

  private

  def user_params
    params.permit(policy([:admin, User]).permitted_attributes)
  end
end
