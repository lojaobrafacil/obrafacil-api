class Api::V2::Admin::EmailTypesController < Api::V2::Admin::BaseController

  def index
    email_types = EmailType.all
    paginate json: email_types.order(:id), status: 200
  end

  def show
    email_type = EmailType.find(params[:id])
    authorize [:admin, email_type]
    render json: email_type, status: 200
  end

  def create
    email_type = EmailType.new(email_type_params)
    authorize [:admin, email_type]
    if email_type.save
      render json: email_type, status: 201
    else
      render json: { errors: email_type.errors }, status: 422
    end
  end

  def update
    email_type = EmailType.find(params[:id])
    authorize [:admin, email_type]
    if email_type.update(email_type_params)
      render json: email_type, status: 200
    else
      render json: { errors: email_type.errors }, status: 422
    end
  end

  def destroy
    email_type = EmailType.find(params[:id])
    authorize [:admin, email_type]
    email_type.destroy
    head 204
  end

  private

  def email_type_params
    params.permit(policy([:admin, EmailType]).permitted_attributes)
  end
end
