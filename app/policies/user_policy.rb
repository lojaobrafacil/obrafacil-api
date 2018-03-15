class UserPolicy < ApplicationPolicy

  def show?
    user.admin? || scope == user 
  end

  class Scope < Scope
    def resolve
      if user&.admin?
        scope.all
      elsif user&.normal?
        user
      end
    end
  end
end