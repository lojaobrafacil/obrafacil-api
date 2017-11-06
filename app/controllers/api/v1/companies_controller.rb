class Api::V1::CompaniesController < ApplicationController

  def index
    companies = Company.all
    render json: {companies: companies}, status: 200
  end

  def show
    company = Company.find(params[:id])
    render json: company, status: 200
  end

  def create
    company = Company.new(client_params)

    if company.save
      render json: company, status: 201
    else
      render json: { errors: company.errors }, status: 422
    end
  end

  def update
    company = Company.find(params[:id])
    if company.update(client_params)
      render json: company, status: 200
    else
      render json: { errors: company.errors }, status: 422
    end
  end

  def destroy
    company = Company.find(params[:id])
    company.destroy
    head 204
  end

  private

  def client_params
    params.require(:company).permit(:name, :fantasy_name, :federal_tax_number,
      :state_registration, :kind, :birth_date, :tax_regime, :description,
      :invoice_sale, :invoice_return, :pis_percent, :confins_percent,
      :icmsn_percent, :between_states_percent, :billing_type_id, :user_id)
  end
end
