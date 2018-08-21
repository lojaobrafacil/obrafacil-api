class Admin::ProductPolicy < Admin::ApplicationPolicyV2
  
  def create?
    Product.where(:id => record.id).exists? && (user.change_products || user.admin)
  end

  def update?
    create?
  end

  def destroy?
    user.admin
  end

  def permitted_attributes
    if user.change_products || user.admin
      [:code, :name, :description, :ncm, :icms, :ipi, :cest, 
        :bar_code, :reduction, :weight, :height, :width, :length, :supplier_id,
        :kind, :active, :unit_id, :sku, :sku_xml, :sub_category_id]
    else
      []
    end
  end

  class Scope < Scope
    def resolve
      if user.change_products || user.admin
        scope.all
      end
    end
  end
end