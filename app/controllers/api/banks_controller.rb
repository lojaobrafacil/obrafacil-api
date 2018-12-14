class Api::BanksController < Api::BaseController
  before_action :set_bank, only: [:show, :update, :destroy]

  def index
    @banks = policy_scope Bank
    paginate json: @banks.as_json(only: [:id, :code, :name, :slug, :description]), status: 200
  end

  def allbanks
    @banks = policy_scope Bank
    render json: @banks, status: 200    
  end

  def show
    authorize @bank
    render json: @bank, status: 200
  end

  def create
    @bank = Bank.new(bank_params)
    authorize @bank
    if @bank.save
      render json: @bank, status: 201
    else
      render json: { errors: @bank.errors }, status: 422
    end
  end

  def update
    authorize @bank
    if @bank.update(bank_params)
      render json: @bank, status: 200
    else
      render json: { errors: @bank.errors }, status: 422
    end
  end

  def destroy
    authorize @bank
    @bank.destroy
    head 204
  end

  private

  def set_bank
    @bank = Bank.find_by(id: params[:id])
    head 404 unless @bank
  end

  def bank_params
    params.permit(policy(Bank).permitted_attributes)
  end
end
