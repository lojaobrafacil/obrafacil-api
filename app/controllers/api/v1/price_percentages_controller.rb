class Api::V1::PricePercentagesController < ApplicationController

  def index
    price_percentages = PricePercentage.all
    render json: price_percentages, status: 200
  end

  def show
    price_percentage = PricePercentage.find(params[:id])
    render json: price_percentage, status: 200
  end

  def create
    price_percentage = PricePercentage.new(price_percentage_params)

    if price_percentage.save
      render json: price_percentage, status: 201
    else
      render json: { errors: price_percentage.errors }, status: 422
    end
  end

  def update
    price_percentage = PricePercentage.find(params[:id])
    if price_percentage.update(price_percentage_params)
      render json: price_percentage, status: 200
    else
      render json: { errors: price_percentage.errors }, status: 422
    end
  end

  def destroy
    price_percentage = PricePercentage.find(params[:id])
    price_percentage.destroy
    head 204
  end

  private

  def price_percentage_params
    params.require(:price_percentage).permit(:margin, :kind)
  end
end
