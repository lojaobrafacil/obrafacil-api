class Api::V1::CashiersController < ApplicationController

  def index
    cashiers = Cashier.all
    render json: {cashiers: cashiers}, status: 200
  end

  def show
    cashier = Cashier.find(params[:id])
    render json: cashier, status: 200
  end

  def create
    cashier = Cashier.new(cashier_params)

    if cashier.save
      render json: cashier, status: 201
    else
      render json: { errors: cashier.errors }, status: 422
    end
  end

  def update
    cashier = Cashier.find(params[:id])

    if cashier.update(cashier_params)
      render json: cashier, status: 200
    else
      render json: { errors: cashier.errors }, status: 422
    end
  end

  def destroy
    cashier = Cashier.find(params[:id])
    cashier.destroy
    head 204
  end

  private

  def cashier_params
    params.require(:cashier).permit(:start_date, :finish_date, :employee, :active, :cashier_payment_attributes => [:payment_method_id, :value])
  end
end
