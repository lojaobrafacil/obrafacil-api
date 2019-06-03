class CityPolicy < ApplicationPolicy
  def show?
    true
  end

  def create?
    user.admin?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

  def permitted_attributes
    if create?
      [:name, :capital, :state_id]
    else
      []
    end
  end

  class Scope < Scope
    def resolve
      scope.all.order(:id)
    end
  end
end
