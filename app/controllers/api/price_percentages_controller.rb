class Api::PricePercentagesController < Api::BaseController
  before_action :authenticate_admin_or_api!

  def index
    @price_percentages = []
    authorize PricePercentage
    Company.all.each do |company|
      @price_percentage = percentage_by_company(company)
      @price_percentages << @price_percentage
    end
    render json: @price_percentages, status: 200
  end

  def show
    @price_percentage = percentage_by_company(Company.find(params[:id]))
    if @price_percentage
      render json: @price_percentage, status: 200
    else
      head 404
    end
  end

  def update
    success = false
    price_percentage_params.each do |price_percentage|
      pp = price_percentage.permit(:margin, :kind)
      begin
        PricePercentage.find_by(company_id: params[:id], kind: pp[:kind]).update(margin: pp[:margin])
        success = true
      rescue
        success = false
        nil
      end
    end
    price_percentage = percentage_by_company(Company.find(params[:id]))
    if success
      render json: price_percentage, status: 200
    else
      render json: {errors: "não foi possivel atualizar"}, status: 422
    end
  end

  private

  def percentage_by_company(company)
    price_percentage = {"company_id": company.id, "company_name": company.name, "company_fantasy_name": company.fantasy_name}
    count = 1
    company.price_percentages.order(:kind).each do |pp|
      price_percentage[("kind_" + count.to_s)] = pp.kind
      price_percentage[("margin_" + count.to_s)] = pp.margin
      count += 1
    end
    price_percentage
  end

  def price_percentage_params
    params.require(policy(PricePercentage).permitted_attributes)
  end
end
