class Api::V1::PricePercentagesController < Api::V1::BaseController

  def index
    price_percentages = if params['company_id']
      PricePercentage.where("company_id = ?", "#{params['company_id']}")
      paginate json: price_percentages.order(:id).as_json(only:[:id, :kind, :margin, :company]), status: 200
    else
      render json: { errors: "Voce deve indicar qual empresa" }, status: 422
    end
  end

  def show
    price_percentage = PricePercentage.find(params[:id])
    render json: price_percentage, status: 200
  end

  def update
    price_percentage_params.each do |price_percentage|
      pp = price_percentage.permit(:margin, :kind)
      begin
        PricePercentage.find_by(company_id: params[:id], kind: pp["kind"]).update(margin: pp["margin"])
      rescue
        render json: { errors: "não foi possível Atualizar" }, status: 422
      end
    end
    
    render json: PricePercentage.where(company_id: params[:id]), status: 200
  end

  private

  def price_percentage_params
    params.require(:price_percentages)
  end
end
