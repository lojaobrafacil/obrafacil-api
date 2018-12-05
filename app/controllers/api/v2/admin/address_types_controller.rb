class Api::V2::Admin::AddressTypesController < Api::BaseController

  def index
    address_types = AddressType.all
    paginate json: address_types.order(:id), status: 200
  end

  def show
    address_type = AddressType.find(params[:id])
    authorize [:admin, address_type]
    render json: address_type, status: 200
  end

  def create
    address_type = AddressType.new(address_type_params)
    authorize [:admin, address_type]
    if address_type.save
      render json: address_type, status: 201
    else
      render json: { errors: address_type.errors }, status: 422
    end
  end

  def update
    address_type = AddressType.find(params[:id])
    authorize [:admin, address_type]
    if address_type.update(address_type_params)
      render json: address_type, status: 200
    else
      render json: { errors: address_type.errors }, status: 422
    end
  end

  def destroy
    address_type = AddressType.find(params[:id])
    authorize [:admin, address_type]
    address_type.destroy
    head 204
  end

  private

  def address_type_params
    params.permit(policy([:admin, AddressType]).permitted_attributes)    
  end
end
