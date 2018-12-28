class ClientPolicy < ApplicationPolicy
  def show?
    Client.where(:id => record.id).exists? && (user.is_a?(Api) || user.change_clients || user.admin)
  end

  def destroy?
    user.is_a?(Api) || user.admin
  end

  def permitted_attributes
    if user.is_a?(Api) || user.change_clients || user.admin
      [:name, :federal_registration, :state_registration,
       :international_registration, :kind, :active, :birth_date, :renewal_date,
       :tax_regime, :description, :order_description, :limit, :billing_type_id, :user_id]
    else
      []
    end
  end

  class Scope < Scope
    def resolve
      if user.is_a?(Api) || user.change_clients || user.admin
        scope.all
      end
    end
  end
end
