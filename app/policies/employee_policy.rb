class EmployeePolicy < ApplicationPolicy
  def show?
    Employee.where(:id => record.id).exists? && (user.is_a?(Api) || user.id == record.id || user.admin)
  end

  def destroy?
    user.is_a?(Api) || user.admin
  end

  def password?
    user.is_a?(Api) || user.id == record.id || user.admin
  end

  def permitted_attributes
    if user.is_a?(Api) || user.admin
      [:name, :email, :federal_registration, :state_registration, :active,
       :birth_date, :renewal_date, :admin, :change_partners, :change_suppliers, :change_clients, :change_cashiers,
       :generate_nfe, :import_xml, :change_products, :order_client, :order_devolution, :order_cost,
       :order_done, :order_price_reduce, :order_inactive, :order_creation, :limit_price_percentage,
       :commission_percent, :description]
    else
      [:name, :email, :federal_registration, :state_registration, :birth_date]
    end
  end

  class Scope < Scope
    def resolve
      if user.is_a?(Api) || user.admin
        scope.all.where.not(email: "admin@admin.com")
      else
        scope.where(id: user.id)
      end
    end
  end
end
