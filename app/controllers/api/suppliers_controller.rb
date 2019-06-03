class Api::SuppliersController < Api::ContactsController
  before_action :set_supplier, only: [:show, :update, :destroy]
  before_action :authenticate_admin_or_api!

  def index
    @suppliers = policy_scope Supplier
    @suppliers = if params[:name]
                   @suppliers.where("LOWER(name) LIKE LOWER(?) and LOWER(fantasy_name) LIKE LOWER(?)", "%#{params[:name]}%", "#{params[:fantasy_name]}%")
                 else
                   @suppliers.all
                 end
    paginate json: @suppliers.as_json(only: [:id, :name, :fantasy_name, :description]), status: 200
  end

  def show
    authorize @supplier
    render json: @supplier, status: 200
  end

  def create
    @supplier = Supplier.new(supplier_params)
    authorize @supplier
    if @supplier.save
      update_contact(@supplier)
      render json: @supplier, status: 201
    else
      render json: {errors: @supplier.errors}, status: 422
    end
  end

  def update
    authorize @supplier
    if @supplier.update(supplier_params)
      update_contact(@supplier)
      render json: @supplier, status: 200
    else
      render json: {errors: @supplier.errors}, status: 422
    end
  end

  def destroy
    authorize @supplier
    @supplier.destroy
    head 204
  end

  private

  def set_supplier
    @supplier = Supplier.find_by(id: params[:id])
    head 404 unless @supplier
  end

  def supplier_params
    params.permit(policy(Supplier).permitted_attributes)
  end
end
