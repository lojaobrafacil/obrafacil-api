class Api::SuppliersController < Api::ContactsController

  def index
    suppliers = policy_scope Supplier
    if suppliers&.empty? or suppliers.nil?
      render json: suppliers, status: 401
    else
    suppliers = if params[:name]
      suppliers.where("LOWER(name) LIKE LOWER(?) and LOWER(fantasy_name) LIKE LOWER(?)", "%#{params[:name]}%", "#{params[:fantasy_name]}%")
      else
        suppliers.all
      end
      paginate json: suppliers.order(:id).as_json(only:[:id, :name, :fantasy_name, :description]), status: 200
    end
  end

  def show
    supplier = Supplier.find(params[:id])
    authorize supplier
    render json: supplier, status: 200
  end

  def create
    supplier = Supplier.new(supplier_params)
    authorize supplier
    if supplier.save
      update_contact(supplier) 
      render json: supplier, status: 201
    else
      render json: { errors: supplier.errors }, status: 422
    end
  end

  def update
    supplier = Supplier.find(params[:id])
    authorize supplier
    if supplier.update(supplier_params)
      update_contact(supplier) 
      render json: supplier, status: 200
    else
      render json: { errors: supplier.errors }, status: 422
    end
  end

  def destroy
    supplier = Supplier.find(params[:id])
    authorize supplier
    supplier.destroy
    head 204
  end

  private

  def supplier_params
    params.permit(policy(Supplier).permitted_attributes)
  end
end
