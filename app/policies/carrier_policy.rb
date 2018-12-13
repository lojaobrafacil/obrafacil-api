class CarrierPolicy < ApplicationPolicy
  
  def show?
    Carrier.where(:id => record.id).exists? && (user.is_a?(Api) || user.admin)
  end
  
  def permitted_attributes
    if user.is_a?(Api) || user.admin
      [:name, :federal_registration, :state_registration, :kind, :description, :active]
    else
      []
    end
  end

  class Scope < Scope
    def resolve
      if user.is_a?(Api) || user.admin
        scope.all
      end
    end
  end
end