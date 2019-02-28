class Api::EmailsController < Api::BaseController
  before_action :authenticate_admin_or_api!

  def index
    @emails = Email.all
    paginate json: @emails, status: 200
  end

  def show
    @email = Email.find_by(id: params[:id])
    if @email
      render json: @email, status: 200
    else
      head 404
    end
  end

  def update
    @email = Email.find_by(id: params[:id])

    if @email.update(email_params)
      render json: @email, status: 200
    else
      render json: {errors: @email.errors}, status: 422
    end
  end

  def destroy
    @email = Email.find(params[:id])
    @email.destroy
    head 204
  end

  private

  def email_params
    params.permit(:email, :contact, :primary, :email_type_id, :emailable_type, :emailable_id)
  end
end
