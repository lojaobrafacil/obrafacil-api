class PhoneTypePolicy < ApplicationPolicy
  
  def show?
    PhoneType.where(:id => record.id).exists? && user.admin
  end

  def permitted_attributes
    if user.admin
      [:name]
    else
      []
    end
  end
end