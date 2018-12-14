class Api::BanksController < Api::BaseController
  def index
    @banks = policy_scope Bank
    paginate json: @banks.as_json(only: [:id, :code, :name, :slug, :description]), status: 200
  end

  def allbanks
    @banks = policy_scope Bank
    render json: @banks, status: 200    
  end

  def show
    @bank = Bank.find_by(id: params[:id])
    if @bank
      authorize @bank
      render json: @bank, status: 200
    else
      head 404
    end
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
    @bank = Bank.find(params[:id])
    authorize @bank
    if @bank.update(bank_params)
      render json: @bank, status: 200
    else
      render json: { errors: @bank.errors }, status: 422
    end
  end

  def destroy
    @bank = Bank.find(params[:id])
    authorize @bank
    @bank.destroy
    head 204
  end

  private

  def bank_params
    params.permit(policy(Bank).permitted_attributes)
  end
end
