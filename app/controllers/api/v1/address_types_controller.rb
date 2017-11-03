class Api::V1::AddressTypesController < ApplicationController

  def index
    address_types = AddressType.all
    render json: {address_types: address_types}, status: 200
  end

  def show
    address_type = AddressType.find(params[:id])
    render json: address_type, status: 200
  end

  def create
    address_type = AddressType.new(address_type_params)

    if address_type.save
      render json: address_type, status: 201
    else
      render json: { errors: address_type.errors }, status: 422
    end
  end

  def update
    address_type = AddressType.find(params[:id])

    if address_type.update(address_type_params)
      render json: address_type, status: 200
    else
      render json: { errors: address_type.errors }, status: 422
    end
  end

  def destroy
    address_type = AddressType.find(params[:id])
    address_type.destroy
    head 204
  end

  private

  def address_type_params
    params.require(:address_type).permit(:name)
  end
end
