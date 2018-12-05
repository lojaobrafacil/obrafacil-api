class Api::V2::Admin::BanksController < Api::BaseController
  def index
    banks = policy_scope [:admin, Bank]
    paginate json: banks.as_json(only: [:id, :code, :name, :slug, :description]), status: 200
  end

  def allbanks
    banks = policy_scope [:admin, Bank]
    render json: banks, status: 200    
  end

  def show
    bank = Bank.find(params[:id])
    authorize [:admin, bank]
    render json: bank, status: 200
  end

  def create
    bank = Bank.new(bank_params)
    authorize [:admin, bank]
    if bank.save
      render json: bank, status: 201
    else
      render json: { errors: bank.errors }, status: 422
    end
  end

  def update
    bank = Bank.find(params[:id])
    authorize [:admin, bank]
    if bank.update(bank_params)
      render json: bank, status: 200
    else
      render json: { errors: bank.errors }, status: 422
    end
  end

  def destroy
    bank = Bank.find(params[:id])
    authorize [:admin, bank]
    bank.destroy
    head 204
  end

  private

  def bank_params
    params.permit(policy([:admin, Bank]).permitted_attributes)
  end
end
