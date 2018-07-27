class Api::V2::BillingTypesController < Api::V2::BaseController
  
  def index
    billing_types = BillingType.all
    if billing_types&.empty? or billing_types.nil? and BillingType.all.size > 0
      render json: billing_types, status: 401
    else
    billing_types = if params[:name]
      billing_types.where("LOWER(name) LIKE LOWER(?) and id LIKE ?", "%#{params[:billing_name]}%", "#{params[:billing_type_id]}%")
      else
        billing_types.all
      end
    paginate json: billing_types.order(:id), status: 200
    end
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
    params.permit(:name)
  end
end
