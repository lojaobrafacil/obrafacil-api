class Api::V2::Admin::EmployeesController < Api::V2::Admin::ContactsController
  
  def index
    employees = Employee.all
    if employees&.empty? or employees.nil? and Employee.all.size > 0
      render json: employees, status: 401
    else
      employees = if params[:name] && params[:federal_registration] 
        employees.where("LOWER(name) LIKE LOWER(?) and federal_registration LIKE ?", "%#{params[:name]}%", "#{params[:federal_registration]}%")
        else
          employees.all
        end
      paginate json: employees.where.not(email:"12345678910@obrafacil.com").order(:id).as_json(only: [:id, :name,:federal_registration, :state_registration, :active, :description]), status: 200
    end
  end

  def show
    employee = Employee.find(params[:id])
    render json: employee, status: 200
  end

  def create
    employee = Employee.new(employee_params)

    if employee.save
      update_contact(employee)
      render json: employee, status: 201
    else
      render json: { errors: employee.errors }, status: 422
    end
  end

  def update
    employee = Employee.find(params[:id])
    if employee.update(employee_params)
      update_contact(employee)
      render json: employee, status: 200
    else
      render json: { errors: employee.errors }, status: 422
    end
  end

  def destroy
    employee = Employee.find(params[:id])
    employee.update(active: false)
    head 204
  end

  private

  def employee_params
    params.permit(:name, :email, :federal_registration, :state_registration, :active, :password, :password_confirmation,
    :birth_date, :renewal_date, :admin, :partner, :client, :cashier, :nfe, :xml, :product, :order_client, 
    :order_devolution, :order_cost, :order_done, :order_price_reduce, :order_inactive, :order_creation, 
    :limit_price_percentage, :commission_percent, :description)
  end
end