class PhoneTypePolicy < ApplicationPolicy
  def show?
    user.admin?
  end

  def permitted_attributes
    if user.admin?
      [:name]
    else
      []
    end
  end
end
