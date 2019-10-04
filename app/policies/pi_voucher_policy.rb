class PiVoucherPolicy < ApplicationPolicy
  def show?
    if user&.is_a?(Api)
      user.admin?
    else
      user.change_partners || user.admin?
    end
  end

  def send_email?
    show?
  end

  def permitted_attributes
    if show?
      [:value, :used_at, :status, :received_at, :company_id, :partner_id]
    end
  end

  def create?
    show?
  end

  def update?
    show?
  end

  class Scope < Scope
    def resolve
      if show?
        scope.all
      end
    end

    def show?
      if user&.is_a?(Api)
        user.admin?
      else
        user.change_partners || user.admin?
      end
    end
  end
end
