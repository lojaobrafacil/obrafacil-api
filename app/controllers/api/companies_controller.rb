class Api::CompaniesController < Api::V2::Admin::ContactsController

  def index
    companies = policy_scope Company 
    companies = if params['name']
      companies.where("LOWER(name) LIKE LOWER(?)", "%#{params['name']}%")
    else
      companies.all
    end
    paginate json: companies.order(:id).as_json(only: [:id, :name, :fantasy_name, :federal_registration]), status: 200
  end

  def show
    company = Company.find(params[:id])
    authorize company
    render json: company, status: 200
  end

  def create
    company = Company.new(company_params)
    authorize company
    if company.save
      update_contact(company)
      render json: company, status: 201
    else
      render json: { errors: company.errors }, status: 422
    end
  end

  def update
    company = Company.find(params[:id])
    authorize company
    if company.update(company_params)
      update_contact(company)
      render json: company, status: 200
    else
      render json: { errors: company.errors }, status: 422
    end
  end

  def destroy
    company = Company.find(params[:id])
    authorize company
    company.destroy
    head 204
  end

  private

  def company_params
    params.permit(policy(Company).permitted_attributes)
  end
end
