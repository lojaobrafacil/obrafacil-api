class Admin::SupplierPolicy < Admin::ApplicationPolicyV2
  
  def show?
    Supplier.where(:id => record.id).exists? && user.admin
  end

  def permitted_attributes
    if user.admin
      [:name, :fantasy_name, :federal_registration,
        :state_registration, :kind, :birth_date, :tax_regime, :description,
        :billing_type_id, :user_id]
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