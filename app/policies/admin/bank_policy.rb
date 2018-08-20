class Admin::BankPolicy < Admin::ApplicationPolicyV2
  def show?
    Bank.where(:id => record.id).exists? && (user.change_partners || user.change_clients || user.admin)
  end

  def create?
    Bank.where(:id => record.id).exists? && user.admin
  end

  def update?
    Bank.where(:id => record.id).exists? && user.admin
  end

  def destroy?
    user.admin
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