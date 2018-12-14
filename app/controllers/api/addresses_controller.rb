class Api::AddressesController < Api::BaseController

  def index
    @addresses = Address.all
    paginate json: @addresses.order(:id), status: 200
  end

  def show
    @address = Address.find_by(id: params[:id])
    if @address_type
      authorize @address_type
      render json: @address_type, status: 200
    else
      head 404
    end
  end

  def update
    @address = Address.find(params[:id])

    if @address.update(address_params)
      render json: @address, status: 200
    else
      render json: { errors: @address.errors }, status: 422
    end
  end

  def destroy
    @address = Address.find(params[:id])
    @address.destroy
    head 204
  end

  private

  def address_params
    params.permit(:street, :neighborhood, :zipcode, :ibge, :number,
          :complement, :description, :addressable_id, :addressable_type, :address_type_id, :city_id)
  end
end
