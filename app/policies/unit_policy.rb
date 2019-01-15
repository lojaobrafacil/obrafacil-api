class UnitPolicy < ApplicationPolicy
  def show?
    Unit.where(:id => record.id).exists? && (user.is_a?(Api) || user.admin)
  end

  def permitted_attributes
    if user.is_a?(Api) || user.admin
      [:name, :description]
    else
      []
    end
  end
end
