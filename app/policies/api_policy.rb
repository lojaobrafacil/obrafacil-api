class ApiPolicy < ApplicationPolicy
  def show?
    if user.is_a?(Api) || user.admin
      return Api.where(:id => record.id).exists?
    else
      return false
    end
  end

  def create?
    if user.is_a?(Api)
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
    if user.is_a?(Api) || user.admin
      [:name, :federal_registration]
    else
      []
    end
  end

  class Scope < Scope
    def resolve
      if user.is_a?(Api) || user.admin
        scope.all.order(:id)
      else
        []
      end
    end
  end
end
