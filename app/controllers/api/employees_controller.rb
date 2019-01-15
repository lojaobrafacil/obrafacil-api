class Api::EmployeesController < Api::ContactsController
  def index
    @employees = policy_scope Employee
    if @employees&.empty? or @employees.nil?
      render json: @employees, status: 200
    else
      @employees = if params[:name] && params[:federal_registration]
                     @employees.where("LOWER(name) LIKE LOWER(?) and federal_registration LIKE ?", "%#{params[:name]}%", "#{params[:federal_registration]}%")
                   else
                     @employees.all
                   end
      paginate json: @employees.order(:id).as_json(only: [:id, :name, :federal_registration, :state_registration, :active, :description]), status: 200
    end
  end

  def show
    @employee = Employee.find_by(id: params[:id])
    if @employee
      authorize @employee
      render json: @employee, status: 200
    else
      head 404
    end
  end

  def create
    @employee = Employee.new(employee_params)
    authorize @employee
    @employee.password = employee_params["federal_registration"].to_s
    @employee.password_confirmation = employee_params["federal_registration"].to_s
    if @employee.save
      update_contact(@employee)
      render json: @employee, status: 201
    else
      render json: {errors: @employee.errors}, status: 422
    end
  end

  def update
    @employee = Employee.find(params[:id])
    authorize @employee
    if @employee.update(employee_params)
      update_contact(@employee)
      render json: @employee, status: 200
    else
      render json: {errors: @employee.errors}, status: 422
    end
  end

  def destroy
    @employee = Employee.find(params[:id])
    authorize @employee
    @employee.update(active: false)
    head 204
  end

  def change_employee_password
    @employee = Employee.find(params[:id])
    authorize @employee
    if @employee.update(employee_password_params)
      render json: {status: "Senha atualizada"}, status: 201
    else
      render json: {errors: {error: "Confirmação de senha incorreta"}}, status: 422
    end
  end

  private

  def employee_password_params
    params.permit(:password, :password_confirmation)
  end

  def employee_params
    params.permit(policy(Employee).permitted_attributes)
  end
end
