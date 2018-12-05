class ProductPolicy < ApplicationPolicy

  def create?
    Product.where(:id => record.id).exists? && (user.change_products || user.admin)
  end
  
  def permitted_attributes
    if user.change_products || user.admin
      [:images]
    else
      []
    end
  end
end