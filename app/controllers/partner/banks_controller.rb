class Partner::BanksController < Partner::BaseController
  def show
    bank = Bank.find(params[:id])
    render json: bank, status: 200
  end
end
