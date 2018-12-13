class ProductPolicy < ApplicationPolicy
  
  def show?
    Product.where(:id => record.id).exists? && (user.is_a?(Api) || user.change_products || user.admin)
  end

  def destroy?
    user.is_a?(Api) || user.admin
  end

  def permitted_attributes
    if user.is_a?(Api) || user.change_products || user.admin
      [:name, :description, :ncm, :icms, :ipi, :cest, 
        :bar_code, :reduction, :weight, :height, :width, :length, :supplier_id,
        :kind, :active, :unit_id, :sku, :sku_xml, :sub_category_id]
    else
      []
    end
  end
end