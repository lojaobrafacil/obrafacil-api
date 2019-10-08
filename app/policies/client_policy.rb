class ClientPolicy < ApplicationPolicy
  def show?
    if user.is_a?(Api)
      user.admin?
    else
      user.change_clients || user.admin?
    end
  end

  def destroy?
    show?
  end

  def permitted_attributes
    if show?
      [:name, :federal_registration, :state_registration,
       :international_registration, :kind, :status, :birthday, :renewal_date,
       :tax_regime, :description, :order_description, :limit, :limit_margin, :billing_type_id, :user_id]
    else
      []
    end
  end

  class Scope < Scope
    def resolve
      if show?
        scope.all
      end
    end

    def show?
      if user.is_a?(Api)
        user.admin?
      else
        user.change_clients || user.admin?
      end
    end
  end
end
