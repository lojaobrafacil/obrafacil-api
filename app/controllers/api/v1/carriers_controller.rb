class Api::V1::CarriersController < Api::V1::BaseController

  def index
    carriers = Carrier.all
    render json: carriers, status: 200
  end

  def show
    carrier = Carrier.find(params[:id])
    render json: carrier, status: 200
  end

  def create
    carrier = Carrier.new(category_params)

    if carrier.save
      render json: carrier, status: 201
    else
      render json: { errors: carrier.errors }, status: 422
    end
  end

  def update
    carrier = Carrier.find(params[:id])

    if carrier.update(category_params)
      render json: carrier, status: 200
    else
      render json: { errors: carrier.errors }, status: 422
    end
  end

  def destroy
    carrier = Carrier.find(params[:id])
    carrier.destroy
    head 204
  end

  private

  def category_params
    params.require(:carrier).permit(:name, :federal_tax_number, :state_registration, :kind, :description, :active)
  end
end
