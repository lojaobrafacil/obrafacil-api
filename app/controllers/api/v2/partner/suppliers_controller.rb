class Api::V2::SuppliersController < Api::V2::ContactsController

  def index
    suppliers = Supplier.all
    if suppliers&.empty? or suppliers.nil? and Supplier.all.size > 0
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
    render json: supplier, status: 200
  end

  def create
    supplier = Supplier.new(supplier_params)

    if supplier.save
      update_contact(supplier)
      update_user(supplier)      
      render json: supplier, status: 201
    else
      render json: { errors: supplier.errors }, status: 422
    end
  end

  def update
    supplier = Supplier.find(params[:id])
    if supplier.update(supplier_params)
      update_contact(supplier)
      update_user(supplier)      
      render json: supplier, status: 200
    else
      render json: { errors: supplier.errors }, status: 422
    end
  end

  def destroy
    supplier = Supplier.find(params[:id])
    supplier.destroy
    head 204
  end

  def update_user(supplier)
    # if user = User.find_by(federal_registration: supplier.federal_tax_number)
    #   user.update(supplier: supplier) unless user.supplier == supplier
    # else
    #   email = supplier.federal_tax_number? ? supplier.federal_tax_number.to_s+"@obrafacil.com" : supplier.emails.first.email rescue nil
    #   unless email&.nil?
    #     supplier.build_user(email: email,
    #                         federal_registration: supplier.federal_tax_number,
    #                         password:"obrafacil2018",
    #                         password_confirmation:"obrafacil2018" ).save
    #   end
    # end
  end

  private

  def supplier_params
    params.permit(:name, :fantasy_name, :federal_tax_number,
      :state_registration, :kind, :birth_date, :tax_regime, :description,
      :billing_type_id, :user_id)
  end
end
