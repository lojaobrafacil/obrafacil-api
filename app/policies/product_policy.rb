class ProductPolicy < ApplicationPolicy
  def show?
    if user&.is_a?(Api)
      user.admin?
    else
      user.change_partners? || user.admin?
    end
  end

  def destroy?
    user.admin?
  end

  def permitted_attributes
    if show?
      [:name, :description, :ipi,
       :barcode, :reduction, :weight, :height, :width, :length, :supplier_id,
       :kind, :status, :unit_id, :sku, :sku_xml, :sub_category_id]
    else
      []
    end
  end
end
