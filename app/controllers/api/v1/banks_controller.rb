class Api::V1::BanksController < ApplicationController
  def index
    banks = Bank.all
    render json: {banks: banks}, status: 200
  end

  def show
    bank = Bank.find(params[:id])
    render json: bank, status: 200
  end

  def create
    bank = Bank.new(bank_params)

    if bank.save
      render json: bank, status: 201
    else
      render json: { errors: bank.errors }, status: 422
    end
  end

  def update
    bank = Bank.find(params[:id])

    if bank.update(bank_params)
      render json: bank, status: 200
    else
      render json: { errors: bank.errors }, status: 422
    end
  end

  def destroy
    bank = Bank.find(params[:id])
    bank.destroy
    head 204
  end

  private

  def bank_params
    params.require(:bank).permit(:code, :name, :slug, :description)
  end
end
