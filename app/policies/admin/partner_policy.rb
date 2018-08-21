class Admin::PartnerPolicy < Admin::ApplicationPolicyV2
  
  def show?
    Partner.where(:id => record.id).exists? && (user.change_partners || user.admin)
  end

  def destroy?
    user.admin
  end

  def permitted_attributes
    if user.change_partners || user.admin
      [:name, :federal_registration, :state_registration, 
        :kind, :active, :started_date, :renewal_date, :description, :origin, :percent, :agency, 
        :ocupation, :account, :favored, :user_id, :bank_id, :discount3, :discount5, :discount8, :cash_redemption]
    else
      []
    end
  end

  class Scope < Scope
    def resolve
      if user.change_partners || user.admin
        scope.all
      end
    end
  end
end