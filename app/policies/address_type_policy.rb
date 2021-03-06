class AddressTypePolicy < ApplicationPolicy
  def show?
    AddressType.where(:id => record.id).exists? && (user.is_a?(Api) || user.admin?)
  end

  def permitted_attributes
    if user.is_a?(Api) || user.admin?
      [:name]
    else
      []
    end
  end
end
