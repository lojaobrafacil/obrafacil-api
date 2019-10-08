class ClientPolicy < ApplicationPolicy
  def show?
    true
  end

  def index?
    true
  end

  def create?
    if user.is_a?(Api)
      user.admin?
    else
      user.change_clients || user.admin?
    end
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

  def permitted_attributes
    if create?
      [:name, :federal_registration, :state_registration,
       :international_registration, :kind, :status, :birthday, :renewal_date,
       :tax_regime, :description, :order_description, :limit, :limit_margin, :billing_type_id, :user_id]
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
