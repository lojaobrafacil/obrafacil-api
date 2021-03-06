class Log::PremioIdealPolicy < ApplicationPolicy
  def show?
    if user&.is_a?(Api)
      user&.admin?
    else
      user&.change_partners || user&.admin?
    end
  end

  def index?
    show?
  end

  class Scope < Scope
    def resolve
      if show?
        scope.all.order("updated_at DESC")
      end
    end

    def show?
      if user&.is_a?(Api)
        user&.admin?
      else
        user&.change_partners || user&.admin?
      end
    end
  end
end
