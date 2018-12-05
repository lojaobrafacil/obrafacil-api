class SupplierPolicy < ApplicationPolicy
  
  def show?
    Supplier.where(:id => record.id).exists? && (user.change_suppliers || user.admin)
  end

  def permitted_attributes
    if user.change_suppliers || user.admin
      [:name, :fantasy_name, :federal_registration, :state_registration, 
        :kind, :birth_date, :tax_regime, :description, :billing_type_id]
    else
      []
    end
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end