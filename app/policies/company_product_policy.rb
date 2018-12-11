class CompanyProductPolicy < ApplicationPolicy
  
  def show?
    CompanyProduct.where(:id => record.id).exists? && (is_api? || user.change_products || user.admin)
  end

  def update?
    is_api? || user.change_products || user.admin
  end

  def update_code_by_product?
    is_api? || user.change_products || user.admin
  end

  def permitted_attributes
    if is_api? || user.change_products || user.admin
      [:code, :stock, :stock_max, :company_id, :stock_min, :cost, :discount, :st, :margin]
    else
      []
    end
  end
end