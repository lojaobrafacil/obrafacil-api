class Api::V2::BanksController < Api::V2::BaseController
  def allbanks
    banks = Bank.all.order(:id)
    render json: banks, status: 200    
  end
end
