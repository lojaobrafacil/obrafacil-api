class CouponPolicy < ApplicationPolicy
  def show?
    if user.is_a?(Api)
      user.admin?
    else
      user.change_partners || user.admin
    end
  end

  def destroy?
    show?
  end

  def by_code?
    if user.is_a?(Api)
      user.admin? || user.reader?
    else
      user.admin?
    end
  end

  def use?
    by_code?
  end

  def permitted_attributes
    if show?
      [:name, :code, :discount, :status, :kind,
       :expired_at, :starts_at, :total_uses,
       :client_uses, :description]
    else
      []
    end
  end
end
