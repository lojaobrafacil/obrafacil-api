class Api::V2::BanksController < Api::V2::Partner::BaseController
  def show
    bank = Bank.find(params[:id])
    render json: bank, status: 200    
  end
end
