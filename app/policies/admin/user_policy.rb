class Admin::UserPolicy < Admin::ApplicationPolicyV2

  def reset_password?
    user.change_partners || user.admin?
  end

  def permitted_attributes
    if user.change_clients || user.change_partners || user.admin
      [:email, :federal_registration, :password, :password_confirmation]
    else
      []
    end
  end
end