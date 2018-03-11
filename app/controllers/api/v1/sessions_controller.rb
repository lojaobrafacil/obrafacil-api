class Api::V1::SessionsController < ApplicationController

  def create
    user = User.find_by(federal_registration: session_params[:federal_registration])
    
    if user&.valid_password?(session_params[:password])
      sign_in user, store: false
      user.generate_authentication_token!
      user.save
      render json: user, status: 200
    else
      render json: {errors: "Dados de usuario incorretos"}, status: 401
    end
  end

  def destroy
    user = User.find_by(auth_token: params[:id])
    user.generate_authentication_token!
    user.save
    head 204
  end
  

  private

  def session_params
    params.require(:session).permit(:federal_registration, :password)
  end
  
end
