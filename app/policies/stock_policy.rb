class StockPolicy < ApplicationPolicy
  def show?
    if user.is_a?(Api)
      user.admin?
    else
      user.change_products? || user.admin?
    end
  end

  def update?
    show?
  end

  def update_code_by_product?
    show?
  end

  def permitted_attributes
    if show?
      [:stock, :stock_max, :stock_min, :cost, :discount,
       :st, :margin, :pmva, :vbc, :vbcst, :vicms, :picms, :vicmsst,
       :picmsst, :company_id, :product_id]
    else
      []
    end
  end

  class Scope < Scope
    def resolve
      if show?
        scope.all
      end
    end

    def show?
      if user.is_a?(Api)
        user.admin?
      else
        user.change_clients || user.admin
      end
    end
  end
end
