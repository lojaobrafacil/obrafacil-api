class Api::V1::BillingTypesController < Api::V1::BaseController
  def index
    billing_types = BillingType.all
    render json: billing_types, status: 200
  end

  def show
    billing_type = BillingType.find(params[:id])
    render json: billing_type, status: 200
  end

  def create
    billing_type = BillingType.new(billing_type_params)

    if billing_type.save
      render json: billing_type, status: 201
    else
      render json: { errors: billing_type.errors }, status: 422
    end
  end

  def update
    billing_type = BillingType.find(params[:id])

    if billing_type.update(billing_type_params)
      render json: billing_type, status: 200
    else
      render json: { errors: billing_type.errors }, status: 422
    end
  end

  def destroy
    billing_type = BillingType.find(params[:id])
    billing_type.destroy
    head 204
  end

  private

  def billing_type_params
    params.require(:billing_type).permit(:name)
  end
end
