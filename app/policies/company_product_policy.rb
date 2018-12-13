class CompanyProductPolicy < ApplicationPolicy
  
  def show?
    CompanyProduct.where(:id => record.id).exists? && (user.is_a?(Api) || user.change_products || user.admin)
  end

  def update?
    user.is_a?(Api) || user.change_products || user.admin
  end

  def update_code_by_product?
    user.is_a?(Api) || user.change_products || user.admin
  end

  def permitted_attributes
    if user.is_a?(Api) || user.change_products || user.admin
      [:code, :stock, :stock_max, :company_id, :stock_min, :cost, :discount, :st, :margin]
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