class ApiPolicy < ApplicationPolicy
  def show?
    if user.is_a?(Api)
      user.admin?
    else
      user.admin?
    end
  end

  def create?
    show?
  end

  def update?
    show?
  end

  def destroy?
    show?
  end

  def permitted_attributes
    if user.admin?
      [:name, :federal_registration]
    else
      []
    end
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all.order(:id)
      else
        []
      end
    end
  end
end
