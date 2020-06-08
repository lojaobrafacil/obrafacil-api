class Api::EmployeesController < Api::BaseController
  before_action :authenticate_admin_or_api!

  def index
    @employees = policy_scope Employee
    filparams = filtered_params
    if !filparams.empty?
      query = []
      query << "LOWER(searcher) ILIKE LOWER('%#{filparams[:searcher]}%')" if filparams[:searcher] && !filparams[:searcher].empty?
      query << "id in (#{filparams[:ids]})" if filparams[:ids] && !filparams[:ids].empty? && filparams[:ids].chomp(",").match?(/^\d+(,\d+)*$/)
      query << "LOWER(name) LIKE LOWER('%#{filparams[:name]}%')" if filparams[:name] && !filparams[:name].empty?
      query << "federal_registration LIKE '#{filparams[:federal_registration]}%'" if filparams[:federal_registration] && !filparams[:federal_registration].empty?
      filparams[:permissions].split(",").map { |permission| query << "#{permission} is TRUE" if Employee.column_names.include? permission } if filparams[:permissions] && !filparams[:permissions].empty?
      query = query.join(" and ")
    end
    @employees = filparams[:searcher] ? @employees.where(query).order("position(LOWER('#{filparams[:searcher]}') in lower(searcher)), id, name") : @employees.where(query).order(:name)
    paginate json: @employees, status: 200, each_serializer: Api::SimpleEmployeeSerializer
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

  def filtered_params
    params.permit(:searcher, :ids, :name, :federal_registration, :permissions)
  end
end
