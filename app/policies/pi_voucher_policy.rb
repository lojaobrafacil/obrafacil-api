class PiVoucherPolicy < ApplicationPolicy
  def show?
    PiVoucher.where(:id => record.id).exists? && (user.is_a?(Api) || user&.change_partners || user&.admin)
  end

  def send_email?
    user.is_a?(Api) || user&.change_partners || user&.admin
  end

  def permitted_attributes
    if user.is_a?(Api) || user&.change_partners || user&.admin
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
      if user.is_a?(Api) || user&.change_partners || user&.admin
        scope.all
      end
    end
  end
end
