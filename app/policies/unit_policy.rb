class UnitPolicy < ApplicationPolicy
  
  def show?
    Unit.where(:id => record.id).exists? && user.admin
  end
    
  def permitted_attributes
    if user.admin
      [:name, :description]
    else
      []
    end
  end
end