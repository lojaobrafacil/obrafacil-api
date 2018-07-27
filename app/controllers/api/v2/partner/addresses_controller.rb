class Api::V2::AddressesController < Api::V2::BaseController

  def index
    addresses = Address.all
    paginate json: addresses.order(:id), status: 200
  end

  def show
    address = Address.find(params[:id])
    render json: address, status: 200
  end
  
end
