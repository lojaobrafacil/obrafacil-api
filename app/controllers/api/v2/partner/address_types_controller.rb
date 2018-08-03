class Api::V2::AddressTypesController < Api::V2::Partner::BaseController

  def index
    address_types = AddressType.all
    paginate json: address_types.order(:id), status: 200
  end

  def show
    address_type = AddressType.find(params[:id])
    render json: address_type, status: 200
  end
end
