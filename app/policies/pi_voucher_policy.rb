class PiVoucherPolicy < ApplicationPolicy
  def show?
    PiVoucher.where(:id => record.id).exists? && (user.is_a?(Api) || user.admin)
  end

  def permitted_attributes
    if user.is_a?(Api) || user.admin
      [:value, :used_at, :status, :received_at, :company_id, :partner_id]
    end
  end

  class Scope < Scope
    def resolve
      if user.is_a?(Api) || user.admin
        scope.all
      end
    end
  end
end
