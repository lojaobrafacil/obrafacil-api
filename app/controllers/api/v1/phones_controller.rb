class Api::V1::PhonesController < ApplicationController

  def index
    phones = Phone.all
    render json: {phones: phones}, status: 200
  end

  def show
    phone = Phone.find(params[:id])
    render json: phone, status: 200
  end

  # emails will only be created in the associated controller
  # def create
  #   phone = Phone.new(phone_params)
  #
  #   if phone.save
  #     render json: phone, status: 201
  #   else
  #     render json: { errors: phone.errors }, status: 422
  #   end
  # end

  def update
    phone = Phone.find(params[:id])

    if phone.update(phone_params)
      render json: phone, status: 200
    else
      render json: { errors: phone.errors }, status: 422
    end
  end

  def destroy
    phone = Phone.find(params[:id])
    phone.destroy
    head 204
  end

  private

  def phone_params
    params.require(:phone).permit(:phone, :phone_type)
  end
end
