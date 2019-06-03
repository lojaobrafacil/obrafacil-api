class SupplierPolicy < ApplicationPolicy
  def show?
    if user&.is_a?(Api)
      user.admin?
    else
      user.change_suppliers? || user.admin?
    end
  end

  def permitted_attributes
    if show?
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
