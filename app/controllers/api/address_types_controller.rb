class Api::AddressTypesController < Api::BaseController
  before_action :authenticate_admin_or_api!

  def index
    @address_types = AddressType.all
    paginate json: @address_types.order(:id), status: 200
  end

  def show
    @address_type = AddressType.find_by(id: params[:id])
    if @address_type
      authorize @address_type
      render json: @address_type, status: 200
    else
      head 404
    end
  end

  def create
    @address_type = AddressType.new(address_type_params)
    authorize @address_type
    if @address_type.save
      render json: @address_type, status: 201
    else
      render json: {errors: @address_type.errors}, status: 422
    end
  end

  def update
    @address_type = AddressType.find(params[:id])
    authorize @address_type
    if @address_type.update(address_type_params)
      render json: @address_type, status: 200
    else
      render json: {errors: @address_type.errors}, status: 422
    end
  end

  def destroy
    @address_type = AddressType.find(params[:id])
    authorize @address_type
    @address_type.destroy
    head 204
  end

  private

  def address_type_params
    params.permit(policy(AddressType).permitted_attributes)
  end
end
