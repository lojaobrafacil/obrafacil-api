class Api::EmployeesController < Api::BaseController
  before_action :authenticate_admin_or_api!

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
      render json: @employee, status: 201
    else
      render json: { errors: @employee.errors.full_messages }, status: 422
    end
  end

  def update
    @employee = Employee.find(params[:id])
    authorize @employee
    if @employee.update(employee_params)
      render json: @employee, status: 200
    else
      render json: { errors: @employee.errors.full_messages }, status: 422
    end
  end

  def destroy
    @employee = Employee.find(params[:id])
    authorize @employee
    @employee.update(active: false)
    head 204
  end

  def password
    @employee = Employee.find(params[:id])
    authorize @employee
    if @employee.update_password(employee_password_params[:old_password], employee_password_params[:password], employee_password_params[:password_confirmation])
      render json: { success: I18n.t("models.employee.success.reset_password") }, status: 201
    else
      render json: { errors: @employee.errors.full_messages }, status: 422
    end
  end

  def reset_password
    @employee = Employee.find(params[:id])
    authorize @employee
    if @employee.reset_password(employee_password_params[:password], employee_password_params[:password_confirmation])
      render json: { success: I18n.t("models.employee.success.reset_password") }, status: 201
    else
      render json: { errors: @employee.errors.full_messages }, status: 422
    end
  end

  private

  def employee_password_params
    params.permit(:password, :password_confirmation, :old_password)
  end

  def employee_params
    params.permit(policy(Employee).permitted_attributes)
  end
end
