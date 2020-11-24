class ProductPolicy < ApplicationPolicy
  def show?
    if user&.is_a?(Api)
      user.admin?
    else
      user.change_products || user.admin?
    end
  end

  def destroy?
    user.admin?
  end

  def permitted_attributes
    if show?
      [:name, :description, :barcode, :weight, :height,
       :width, :length, :color, :kind, :sub_category_id, :unit_id,
       :sku, :sku_xml, :ipi, :reduction, :suggested_price, :supplier_id,
       :suggested_price_site, :suggested_price_role, :status, :supplier_discount,
       :cost, :tax_replacement, :contribution_margin, :pmva, :vbc, :vbcst, :vicms,
       :picms, :vicmsst, :picmsst, :freight, :st, :tax_reduction, :icms, :cest, :ncm,
       images: [], stocks_attributes: [
         :id, :stock, :stock_max, :stock_min,
         :company_id, :product_id,
       ]]
    else
      []
    end
  end
end
