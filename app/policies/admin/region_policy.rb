class Admin::RegionPolicy < Admin::ApplicationPolicyV2

  def create?
    Region.where(:id => record.id).exists? && user.admin
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

  def permitted_attributes
    if user.admin
      [:name]
    else
      []
    end
  end

  class Scope < Scope
    def resolve
      scope.all.order(:id)
    end
  end
end