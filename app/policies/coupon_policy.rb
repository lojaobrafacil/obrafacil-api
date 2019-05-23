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

  def permitted_attributes
    if show?
      [:name, :code, :discount, :status, :kind, :max_value, :expired_at,
       :starts_at, :total_uses, :client_uses, :shipping, :logged, :description]
    else
      []
    end
  end
end
