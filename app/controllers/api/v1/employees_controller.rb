class Api::V1::EmployeesController < Api::V1::ContactsController

  def index
    employees = Employee.all
    paginate json: employees.order(:id).as_json(only: [:id, :name, :federal_tax_number, :state_registration, :active, :description]), status: 200
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
    employee.destroy
    head 204
  end

  private

  def employee_params
    params.permit(:name, :federal_tax_number, :state_registration,
      :active, :birth_date, :renewal_date, :commission_percent, :description, :user_id)
  end
end
