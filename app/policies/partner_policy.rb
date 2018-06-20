class PartnerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user&.admin?
        scope.all
      elsif user&.normal?
        user.partner
      end
    end
  end
end