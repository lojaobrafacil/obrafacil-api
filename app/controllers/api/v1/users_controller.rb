class Api::V1::UsersController < Api::V1::BaseController

  def index
    users = policy_scope User
    paginate json: users.order(:id), status: 200
  end

  def show
    user = User.find(params[:id])
    authorize user
    render json: user, status: 200
  end

  def update
    user = User.find(params[:id])

    if user.update(user_params)
      render json: user, status: 200
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:id, :email, :federal_registration, :password, :password_confirmation)
  end
end
