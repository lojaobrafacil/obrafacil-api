class PartnerPolicy < ApplicationPolicy
  def show?
    Partner.where(:id => record.id).exists? && (user.is_a?(Api) || user&.change_partners || user&.admin)
  end

  def create?
    user.is_a?(Api) || user&.change_partners || user&.admin
  end

  def reset?
    user.is_a?(Api) || user&.change_partners || user&.admin
  end

  def destroy?
    user.is_a?(Api) || user&.admin
  end

  def reset_password?
    user.is_a?(Api) || user&.change_partners || user&.admin
  end

  def permitted_attributes
    if user.is_a?(Api) || user&.change_partners || user&.admin
      [:name, :federal_registration, :state_registration,
       :kind, :status, :started_date, :renewal_date, :description, :origin, :percent, :agency,
       :ocupation, :account, :favored, :user_id, :bank_id, :discount3, :discount5, :discount8, :cash_redemption]
    else
      []
    end
  end

  class Scope < Scope
    def resolve
      if user.is_a?(Api) || user&.change_partners || user&.admin
        ::Partner.all
      end
    end
  end
end
