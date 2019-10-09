class ProductPolicy < ApplicationPolicy
  def show?
    if user&.is_a?(Api)
      user.admin?
    else
      user.change_partners || user.admin?
    end
  end

  def destroy?
    user.admin?
  end

  def permitted_attributes
    if show?
      [:id, :name, :barcode, :weight, :height, :width,
       :length, :color, :kind, :sku, :sku_xml, :ipi, :reduction,
       :suggested_price, :supplier_id, :suggested_price_site, :suggested_price_role,
       :status, :description, :sub_category_id, :unit_id, :supplier_id,
       stocks_attributes: [:id, :stock, :stock_max, :stock_min, :cost, :discount,
                           :st, :margin, :pmva, :vbc, :vbcst, :vicms, :picms, :vicmsst,
                           :picmsst, :company_id, :product_id],
       images: []]
    else
      []
    end
  end
end
