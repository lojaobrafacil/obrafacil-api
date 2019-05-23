class CommissionPolicy < ApplicationPolicy
  def show?
    user.admin?
  end

  def permitted_attributes
    if user.admin?
      [:partner_id, :order_id, :order_date, :order_price,
       :client_name, :return_price, :points, :percent, :percent_date, :sent_date]
    else
      []
    end
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
