class UserPolicy < ApplicationPolicy
  def show?
    if user&.is_a?(Api)
      user.admin?
    else
      user.change_clients || user.change_partners || user.admin?
    end
  end

  def permitted_attributes
    if show?
      [:email, :federal_registration, :password, :password_confirmation]
    else
      []
    end
  end
end
