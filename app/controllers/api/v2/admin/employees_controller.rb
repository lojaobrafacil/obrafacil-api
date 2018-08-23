class Api::V2::Admin::EmployeesController < Api::V2::Admin::ContactsController

  def index
    employees = policy_scope [:admin, Employee]
    if employees&.empty? or employees.nil?
      render json: employees, status: 401
    else
      employees = if params[:name] && params[:federal_registration] 
        employees.where("LOWER(name) LIKE LOWER(?) and federal_registration LIKE ?", "%#{params[:name]}%", "#{params[:federal_registration]}%")
        else
          employees.all
        end
      paginate json: employees.order(:id).as_json(only: [:id, :name,:federal_registration, :state_registration, :active, :description]), status: 200
    end
  end

  def show
    employee = Employee.find(params[:id])
    authorize [:admin, employee]
    render json: employee, status: 200
  end

  def create
    employee = Employee.new(employee_params)
    authorize [:admin, employee]
    employee.password = employee_params['federal_registration'].to_s 
    employee.password_confirmation = employee_params['federal_registration'].to_s 
    if employee.save
      update_contact(employee)
      render json: employee, status: 201
    else
      render json: { errors: employee.errors }, status: 422
    end
  end

  def update
    employee = Employee.find(params[:id])
    authorize [:admin, employee]

    if employee.update(employee_params)
      update_contact(employee)
      render json: employee, status: 200
    else
      render json: { errors: employee.errors }, status: 422
    end
  end

  def destroy
    employee = Employee.find(params[:id])
    authorize [:admin, employee]
    employee.update(active: false)
    head 204
  end

  private

  def employee_params
    params.permit(policy([:admin, Employee]).permitted_attributes)
  end
end