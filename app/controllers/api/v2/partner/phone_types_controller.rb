class Api::V2::PhoneTypesController < Api::V2::Partner::BaseController

  def index
    phone_types = PhoneType.all
    paginate json: phone_types.order(:id), status: 200
  end

  def show
    phone_type = PhoneType.find(params[:id])
    render json: phone_type, status: 200
  end
end
