class UnitPolicy < ApplicationPolicy
  def show?
    user.admin?
  end

  def permitted_attributes
    if user.admin?
      [:name, :description]
    else
      []
    end
  end
end
