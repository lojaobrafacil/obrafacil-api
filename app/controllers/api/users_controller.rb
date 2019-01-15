class Api::UsersController < Api::BaseController
  def reset_password
    authorize User
    user = User.where(federal_registration: params[:federal_registration]).first
    if user && user.reset_password(params[:password], params[:password_confirmation])
      render json: {status: "Ok"}, status: 205
    else
      render json: {errors: {error: "usuario não existe ou password_confirmation incorreto"}}, status: 422
    end
  end

  private

  def user_params
    params.permit(policy(User).permitted_attributes)
  end
end
