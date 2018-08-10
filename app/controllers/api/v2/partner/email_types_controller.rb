class Api::V2::EmailTypesController < Api::V2::Partner::BaseController

  def index
    email_types = EmailType.all
    paginate json: email_types.order(:id), status: 200
  end

  def show
    email_type = EmailType.find(params[:id])
    render json: email_type, status: 200
  end
end
