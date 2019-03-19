class PiVoucherPolicy < ApplicationPolicy
  def show?
    true
    # PiVoucher.where(:id => record.id).exists? && (user.is_a?(Api) || user&.change_partners || user&.admin)
  end

  def permitted_attributes
    if true
      [:value, :used_at, :status, :received_at, :company_id, :partner_id]
    end
  end

  class Scope < Scope
    def resolve
      if true
        scope.all
      end
    end
  end
end
