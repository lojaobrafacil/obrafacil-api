class PartnerProjectPolicy < ApplicationPolicy
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

  def images?
    show?
  end

  def image_position?
    show?
  end

  def permitted_attributes
    if show?
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
