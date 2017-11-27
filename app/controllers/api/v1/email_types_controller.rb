class Api::V1::EmailTypesController < Api::V1::BaseController

  def index
    email_types = EmailType.all
    paginate json: email_types, status: 200
  end

  def show
    email_type = EmailType.find(params[:id])
    render json: email_type, status: 200
  end

  def create
    email_type = EmailType.new(email_type_params)

    if email_type.save
      render json: email_type, status: 201
    else
      render json: { errors: email_type.errors }, status: 422
    end
  end

  def update
    email_type = EmailType.find(params[:id])
    if email_type.update(email_type_params)
      render json: email_type, status: 200
    else
      render json: { errors: email_type.errors }, status: 422
    end
  end

  def destroy
    email_type = EmailType.find(params[:id])
    email_type.destroy
    head 204
  end

  private

  def email_type_params
    params.require(:email_type).permit(:name)
  end
end
