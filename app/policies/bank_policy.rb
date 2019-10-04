class BankPolicy < ApplicationPolicy
  def show?
    if user.is_a?(Api)
      user.admin?
    else
      user.change_partners || user.change_clients || user.admin?
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
    if show?
      [:code, :name, :slug, :description]
    else
      []
    end
  end

  class Scope < Scope
    def resolve
      if show?
        scope.all.order(:id)
      else
        []
      end
    end

    def show?
      if user.is_a?(Api)
        user.admin?
      else
        user.change_partners || user.change_clients || user.admin
      end
    end
  end
end
