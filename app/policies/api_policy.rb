class ApiPolicy < ApplicationPolicy

  def show?
    if is_api || user.admin
      return Api.where(:id => record.id).exists?
    else
      return false
    end
  end
  
  def create?
    if is_api
      return true
    else
      return user.admin
    end
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

  def permitted_attributes
    if is_api || user.admin
      [:name, :federal_registration]
    else
      []
    end
  end

  class Scope < Scope
    def resolve
      if is_api || user.admin
        scope.all.order(:id)
      else
        []
      end
    end
  end
end