class Api::V1::PricePercentagesController < Api::V1::BaseController

  def index
    price_percentages = []

    Company.all.each do |company|
      pp = {"company_id": company.id, "company_name": company.name, "company_fantasy_name": company.fantasy_name}
      count = 1
      company.price_percentages.each do |price_percentage|
        pp[("kind_"+count.to_s)]= price_percentage.kind
        pp[("margin_"+count.to_s)]= price_percentage.margin
        count+=1
      end
      price_percentages << pp
    end

    render json: price_percentages, status: 200
  end

  def show
    price_percentage = PricePercentage.find(params[:id])
    render json: price_percentage, status: 200
  end

  def update
    price_percentage_params.each do |price_percentage|
      pp = price_percentage.permit(:margin, :kind)
      begin
        pp1 = PricePercentage.find_by(company_id: params[:id], kind: pp["kind"])
        if pp1 
          pp1.update(margin: pp["margin"])
        else
          PricePercentage.create!(margin: pp["margin"], company_id: params[:id], kind: pp["kind"])
        end
      rescue
        nil
      end
    end
    
    render json: PricePercentage.where(company_id: params[:id]), status: 200
  end

  private

  def price_percentage_params
    params.require(:price_percentages)
  end
end
