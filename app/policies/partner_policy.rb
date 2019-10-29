class PartnerPolicy < ApplicationPolicy
  def show?
    if user&.is_a?(Api)
      user&.admin?
    else
      user&.change_partners || user&.admin?
    end
  end

  def index?
    true
  end

  def create?
    show?
  end

  def reset?
    show?
  end

  def destroy?
    show?
  end

  def reset_password?
    show?
  end

  def permitted_attributes
    if user&.is_a?(Api) && user&.admin?
      [:name, :federal_registration, :state_registration,
       :kind, :status, :birthday, :renewal_date, :description, :origin, :percent, :agency,
       :ocupation, :account, :favored, :user_id, :bank_id, :cash_redemption]
    elsif show?
      [:name, :federal_registration, :state_registration,
       :kind, :status, :birthday, :renewal_date, :description, :origin, :percent, :agency,
       :ocupation, :account, :favored, :user_id, :bank_id, :cash_redemption, :deleted_by_id]
    else
      []
    end
  end

  class Scope < Scope
    def resolve
      ::Partner.all
    end
  end
end
