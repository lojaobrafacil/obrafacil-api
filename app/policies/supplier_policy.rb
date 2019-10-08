class SupplierPolicy < ApplicationPolicy
  def show?
    if user&.is_a?(Api)
      user.admin?
    else
      user.change_suppliers? || user.admin?
    end
  end

  def permitted_attributes
    if show?
      [:name, :fantasy_name, :federal_registration, :state_registration,
       :kind, :birth_date, :tax_regime, :description, :billing_type_id,
       addresses_attributes: [:id, :street, :number, :complement, :neighborhood, :zipcode,
                              :description, :address_type_id, :city_id, :_destroy],
       phones_attributes: [:id, :phone, :contact, :phone_type_id, :primary, :_destroy],
       emails_attributes: [:id, :email, :contact, :email_type_id, :primary, :_destroy]]
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
