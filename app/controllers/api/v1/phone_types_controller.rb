class Api::V1::PhoneTypesController < Api::V1::BaseController

  def index
    phone_types = PhoneType.all
    render json: phone_types, status: 200
  end

  def show
    phone_type = PhoneType.find(params[:id])
    render json: phone_type, status: 200
  end

  def create
    phone_type = PhoneType.new(phone_type_params)

    if phone_type.save
      render json: phone_type, status: 201
    else
      render json: { errors: phone_type.errors }, status: 422
    end
  end

  def update
    phone_type = PhoneType.find(params[:id])
    if phone_type.update(phone_type_params)
      render json: phone_type, status: 200
    else
      render json: { errors: phone_type.errors }, status: 422
    end
  end

  def destroy
    phone_type = PhoneType.find(params[:id])
    phone_type.destroy
    head 204
  end

  private

  def phone_type_params
    params.require(:phone_type).permit(:name)
  end
end
