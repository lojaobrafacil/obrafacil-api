class PartnerPolicy < ApplicationPolicy
  def show?
    if user&.is_a?(Api)
      user.admin?
    else
      user.change_partners? || user.admin?
    end
  end

  def create?
    show?
  end

  def reset?
    show?
  end

  def destroy?
    user&.admin?
  end

  def reset_password?
    show?
  end

  def permitted_attributes
    if user&.is_a?(Api) && user.admin?
      [:name, :federal_registration, :state_registration,
       :kind, :status, :started_date, :renewal_date, :description, :origin, :percent, :agency,
       :ocupation, :account, :favored, :user_id, :bank_id, :cash_redemption]
    elsif show?
      [:name, :federal_registration, :state_registration,
       :kind, :status, :started_date, :renewal_date, :description, :origin, :percent, :agency,
       :ocupation, :account, :favored, :user_id, :bank_id, :cash_redemption, :deleted_by_id]
    else
      []
    end
  end

  class Scope < Scope
    def resolve
      if show?
        ::Partner.all
      end
    end

    def show?
      if user.is_a?(Api)
        user.admin?
      else
        user.change_partners? || user.admin?
      end
    end
  end
end