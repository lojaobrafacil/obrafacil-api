class RegionPolicy < ApplicationPolicy

  def show?
    true
  end
  
  def update?
    create?
  end

  def destroy?
    create?
  end

  def permitted_attributes
    if user.admin
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