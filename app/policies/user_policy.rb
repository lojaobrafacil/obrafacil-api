class UserPolicy < ApplicationPolicy
  def permitted_attributes
    if user.is_a?(Api) || user.change_clients || user.change_partners || user.admin
      [:email, :federal_registration, :password, :password_confirmation]
    else
      []
    end
  end
end
