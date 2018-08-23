class Api::V2::Admin::CarriersController < Api::V2::Admin::ContactsController

  def index
    carriers = policy_scope [:admin, Carrier]
    paginate json: carriers.order(:id), status: 200
  end

  def show
    carrier = Carrier.find(params[:id])
    authorize [:admin, carrier]
    render json: carrier, status: 200
  end

  def create
    carrier = Carrier.new(category_params)
    authorize [:admin, carrier]
    if carrier.save
      update_contact(carrier)
      render json: carrier, status: 201
    else
      render json: { errors: carrier.errors }, status: 422
    end
  end

  def update
    carrier = Carrier.find(params[:id])
    authorize [:admin, carrier]
    if carrier.update(category_params)
      update_contact(carrier)
      render json: carrier, status: 200
    else
      render json: { errors: carrier.errors }, status: 422
    end
  end

  def destroy
    carrier = Carrier.find(params[:id])
    authorize [:admin, carrier]
    carrier.destroy
    head 204
  end

  private

  def category_params
    params.permit(policy([:admin, Carrier]).permitted_attributes)
  end
end
