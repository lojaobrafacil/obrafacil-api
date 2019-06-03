class EmailTypePolicy < ApplicationPolicy
  def show?
    EmailType.where(:id => record.id).exists? && user.admin?
  end

  def permitted_attributes
    if user.admin?
      [:name]
    else
      []
    end
  end
end
