class Api::V2::EmailsController < Api::V2::Partner::BaseController

  def index
    emails = Email.all
    paginate json: emails, status: 200
  end

  def show
    email = Email.find(params[:id])
    render json: email, status: 200
  end
end
