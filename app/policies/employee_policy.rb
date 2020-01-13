class EmployeePolicy < ApplicationPolicy
  def show?
    if user.is_a?(Api)
      user.admin?
    else
      user.id == record.id || user.admin? || user.change_employee?
    end
  end

  def destroy?
    if user.is_a?(Api)
      user.admin?
    else
      user.admin?
    end
  end

  def password?
    user.id == record.id
  end

  def reset_password?
    user.admin?
  end

  def permitted_attributes
    if user.admin?
      [:id, :name, :email, :federal_registration, :state_registration, :active,
       :birth_date, :renewal_date, :admin, :change_partners, :change_clients, :change_suppliers,
       :change_cashiers, :generate_nfe, :import_xml, :change_products, :order_client, :order_devolution,
       :order_cost, :order_done, :order_price_reduce, :order_inactive, :order_creation, :limit_margin,
       :change_coupon, :change_campain, :change_highlight, :change_bank, :change_carrier, :change_employee,
       :commission_percent, :description, :street, :number, :complement, :neighborhood, :zipcode,
       :phone, :celphone, :city_id, :company_id]
    else
      [:name, :email, :federal_registration, :state_registration, :birth_date]
    end
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all.where.not(email: "admin@admin.com")
      else
        scope.where(id: user.id)
      end
    end
  end
end
