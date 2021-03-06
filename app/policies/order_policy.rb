class OrderPolicy < ApplicationPolicy
  def show?
    if user.is_a?(Api)
      user.admin?
    else
      user.change_products? || user.admin?
    end
  end

  def permitted_attributes
    if user.admin?
      [:kind, :exclusion_at, :description, :discount, :order_id,
       :freight, :billing_at, :file, :selected_margin, :employee_id,
       :client_id, :cashier_id, :carrier_id, :company_id]
    elsif !user.is_a?(Api) && user.order_creation?
      [:kind, :exclusion_at, :description, :discount, :order_id,
       :freight, :billing_at, :file, :selected_margin, :employee_id,
       :client_id, :cashier_id, :carrier_id, :company_id]
    else
      []
    end
  end
end
