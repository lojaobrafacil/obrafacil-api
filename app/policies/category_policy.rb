class CategoryPolicy < ApplicationPolicy
  def show?
    true
  end

  def create?
    if user.is_a?(Api)
      user.admin?
    else
      user.change_products? || user.admin?
    end
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

  def permitted_attributes
    if user.admin?
      [:name]
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
