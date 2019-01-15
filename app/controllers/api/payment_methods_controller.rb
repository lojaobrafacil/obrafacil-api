class Api::PaymentMethodsController < Api::BaseController
  def index
    @payment_methods = PaymentMethod.all
    paginate json: @payment_methods.order(:id), status: 200
  end

  def show
    @payment_method = PaymentMethod.find_by(id: params[:id])
    if @payment_method
      render json: @payment_method, status: 200
    else
      head 404
    end
  end

  def create
    @payment_method = PaymentMethod.new(payment_method_params)
    if @payment_method.save
      render json: @payment_method, status: 201
    else
      render json: {errors: @payment_method.errors}, status: 422
    end
  end

  def update
    @payment_method = PaymentMethod.find(params[:id])
    if @payment_method.update(payment_method_params)
      render json: @payment_method, status: 200
    else
      render json: {errors: @payment_method.errors}, status: 422
    end
  end

  def destroy
    @payment_method = PaymentMethod.find(params[:id])
    @payment_method.destroy
    head 204
  end

  private

  def payment_method_params
    params.permit(:name)
  end
end
