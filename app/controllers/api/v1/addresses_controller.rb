class Api::V1::AddressesController < ApplicationController

  def index
    addresses = Address.all
    render json: {addresses: addresses}, status: 200
  end

  def show
    address = Address.find(params[:id])
    render json: address, status: 200
  end

  def create
    address = Address.new(address_params)

    if address.save
      render json: address, status: 201
    else
      render json: { errors: address.errors }, status: 422
    end
  end

  def update
    address = Address.find(params[:id])

    if address.update(address_params)
      render json: address, status: 200
    else
      render json: { errors: address.errors }, status: 422
    end
  end

  def destroy
    address = Address.find(params[:id])
    address.destroy
    head 204
  end

  private

  def address_params
    params.require(:address).permit(:street, :neighborhood, :zipcode, :ibge, :gia,
          :complement, :description, :addressable_id, :addressable_type, :address_type_id, :city_id)
  end
end
