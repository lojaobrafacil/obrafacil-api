class Admin::OrderPolicy < Admin::ApplicationPolicyV2

  def show?
    Order.where(:id => record.id).exists? && (user.change_products || user.admin)
  end
  
  def permitted_attributes
    if user.admin
      [:kind, :exclusion_date, :description, :discont, :order_id,
        :freight, :billing_date, :file, :price_percentage_id, :employee_id,
        :client_id, :cashier_id, :carrier_id, :company_id]
    elsif user.order_creation
      [:kind, :exclusion_date, :description, :discont, :order_id,
        :freight, :billing_date, :file, :price_percentage_id, :employee_id,
        :client_id, :cashier_id, :carrier_id, :company_id]
    elsif true
      [:kind, :exclusion_date, :description, :discont, :order_id,
        :freight, :billing_date, :file, :price_percentage_id, :employee_id,
        :client_id, :cashier_id, :carrier_id, :company_id]
    else
      []
    end
  end
end