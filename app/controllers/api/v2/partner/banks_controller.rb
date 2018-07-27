class Api::V2::BanksController < Api::V2::Partner::BaseController
  def allbanks
    banks = Bank.all.order(:id)
    render json: banks, status: 200    
  end
end
