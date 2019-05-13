class Api::PhonesController < Api::BaseController
  before_action :authenticate_admin_or_api!

  def index
    @phones = Phone.all
    paginate json: @phones.order(:id), status: 200
  end

  def show
    @phone = Phone.find_by(id: params[:id])
    if @phone
      render json: @phone, status: 200
    else
      head 404
    end
  end

  def create
    @phone = Phone.new(phone_params)

    if @phone.save
      render json: @phone, status: 201
    else
      render json: { errors: @phone.errors }, status: 422
    end
  end

  def update
    @phone = Phone.find_by(id: params[:id])

    if @phone.update(phone_params)
      render json: @phone, status: 200
    else
      render json: { errors: @phone.errors }, status: 422
    end
  end

  def destroy
    @phone = Phone.find(params[:id])
    @phone.destroy
    head 204
  end

  private

  def phone_params
    params.permit(:phone, :contact, :primary, :phone_type_id, :phonable_id, :phonable_type)
  end
end
