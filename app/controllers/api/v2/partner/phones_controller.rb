class Api::V2::PhonesController < Api::V2::Partner::BaseController

  def index
    phones = Phone.all
    paginate json: phones.order(:id), status: 200
  end

  def show
    phone = Phone.find(params[:id])
    render json: phone, status: 200
  end
end
