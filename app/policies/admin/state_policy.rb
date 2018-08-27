class Admin::StatePolicy < Admin::ApplicationPolicyV2

  def show?
    true
  end
  
  def update?
    create?
  end

  def destroy?
    create?
  end

  def permitted_attributes
    if user.admin
      [:name, :acronym,:region_id]
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