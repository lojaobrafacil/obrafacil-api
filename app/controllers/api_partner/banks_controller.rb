class ApiPartner::BanksController < ApplicationController
  def index
    bank = Bank.all
    render json: bank.as_json(only: [:id, :name, :code]), status: 200
  end

  def show
    bank = Bank.find(params[:id])
    render json: bank, status: 200
  end
end
