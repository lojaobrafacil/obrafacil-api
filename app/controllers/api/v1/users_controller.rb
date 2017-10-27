class Api::V1::UsersController < ApplicationController

	def show
    begin
      @user = User.find(params[:id])
      render json: @user
    rescue
      head 404
    end
	end

end
