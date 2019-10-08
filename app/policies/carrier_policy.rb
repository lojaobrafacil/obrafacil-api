class CarrierPolicy < ApplicationPolicy
  def show?
    Carrier.where(:id => record.id).exists? && user.admin?
  end

  def permitted_attributes
    if user.admin?
      [:name, :federal_registration, :state_registration, :kind, :description, :active,
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
      if user.admin?
        scope.all
      end
    end
  end
end
