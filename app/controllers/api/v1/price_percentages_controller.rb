class Api::V1::PricePercentagesController < Api::V1::BaseController

  def index
    price_percentages = if params['company_id']
      PricePercentage.where("company_id = ?", "#{params['company_id']}")
    else
      PricePercentage.all
    end
    paginate json: price_percentages.order(:id).as_json(only:[:id, :kind, :margin, :company]), status: 200
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
    arr =[] 
    price_percentages = PricePercentage.where("company_id = #{params[:id]}")
    price_percentages.each do |price|
      price.update(price_percentage_params)
      puts price
      # arr << price
    end
    # price_percentage = PricePercentage.find(params[:id])
    # if price_percentage.update(price_percentage_params)
    if arr 
    render json: arr, status: 200
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
    params.permit(:margin, :kind, :company_id)
    # data = params[:_json]
    # data.each do |items|
    #   items
    # end
    data = require.params(:_json)
      data.each do |item|
      pp = item.permit(:id, :margin, :kind)
      # company.price_percentage.create(pp)
      pp
    end

  end
end
