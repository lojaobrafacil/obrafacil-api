class ProductPolicy < ApplicationPolicy

  def create?
    Product.where(:id => record.id).exists? && (user.is_a?(Api) || user.change_products || user.admin)
  end
  
  def permitted_attributes
    if user.is_a?(Api) || user.change_products || user.admin
      [:images]
    else
      []
    end
  end
end