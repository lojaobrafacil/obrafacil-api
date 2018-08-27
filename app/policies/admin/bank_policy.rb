class Admin::BankPolicy < Admin::ApplicationPolicyV2
  def show?
    Bank.where(:id => record.id).exists? && (user.change_partners || user.change_clients || user.admin)
  end
  
  def update?
    create?
  end

  def destroy?
    create?
  end

  def permitted_attributes
    if user.admin
      [:code, :name, :slug, :description]
    else
      []
    end
  end

  class Scope < Scope
    def resolve
      if user.change_partners || user.change_clients || user.admin
        scope.all.order(:id)
      else
        []
      end
    end
  end
end