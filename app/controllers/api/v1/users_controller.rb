class Api::V1::UsersController < ApplicationController

	def show
    begin
      @user = User.find(params[:id])
      render json: @user
    rescue
      head 404
    end
	end

  def create
    user = User.new(user_params)

    if user.save
      render json: user, status: 201
    else
      render json: user.errors, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confimation)
  end

end
