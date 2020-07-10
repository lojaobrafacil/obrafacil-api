class DeliveryPolicy < ApplicationPolicy
  def show?
    user
  end

  class Scope < Scope
    def resolve
      if user&.is_a?(Api) && user&.admin?
        scope.all
      elsif (user&.admin || user&.can_check_order)
        scope.all
      elsif user&.can_deliver
        scope.where(deliver_id: user.id)
      else
        []
      end
    end
  end
end
