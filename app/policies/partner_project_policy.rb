class PartnerProjectPolicy < ApplicationPolicy
  def show?
    user.admin?
  end

  def permitted_attributes
    if user.admin?
      [:name, :project_date, :content, :environment,
       :products, :city, :partner_id, :status, :status_rmk,
       { images: [] }]
    else
      []
    end
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
