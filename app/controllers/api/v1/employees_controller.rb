class Api::V1::EmployeesController < Api::V1::ContactsController

  def index
    employees = Client.all
    if employees&.empty? or employees.nil? and Client.all.size > 0
      render json: employees, status: 401
    else
      employees = if params[:name] && params[:federal_tax_number] 
        employees.where("LOWER(name) LIKE LOWER(?) and federal_tax_number LIKE ?", "%#{params[:name]}%", "#{params[:federal_tax_number]}%")
        else
          employees.all
        end
      paginate json: employees.order(:id).as_json(only: [:id, :name,:federal_tax_number, :state_registration, :active, :description]), status: 200
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
      update_user(employee)
      render json: employee, status: 201
    else
      render json: { errors: employee.errors }, status: 422
    end
  end

  def update
    employee = Employee.find(params[:id])
    if employee.update(employee_params)
      update_contact(employee)
      update_user(employee)
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

  def update_user(employee)
    if user = User.find_by(federal_registration: employee.federal_tax_number)
      if employee.active?
        user.update(employee: employee) unless user.employee == employee 
      else
        user.destroy unless user.employee.active?
      end
    else
      email = employee.federal_tax_number? ? employee.federal_tax_number.to_s+"@obrafacil.com" : employee.emails.first.email rescue nil
      unless email&.nil?
        employee.build_user(email: email,
                            federal_registration: employee.federal_tax_number,
                            kind:1,
                            password:"obrafacil2018",
                            password_confirmation:"obrafacil2018" ).save
      end
    end
  end

  def employee_params
    params.permit(:name, :federal_tax_number, :state_registration,
      :active, :birth_date, :renewal_date, :commission_percent, :description, :user_id)
  end
end
