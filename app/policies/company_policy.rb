class CompanyPolicy < ApplicationPolicy
  def show?
    Company.where(:id => record.id).exists? && user.admin?
  end

  def permitted_attributes
    if user.admin?
      [:name, :fantasy_name, :federal_registration,
       :state_registration, :birth_date, :tax_regime, :description,
       :invoice_sale, :invoice_return, :pis_percent, :confins_percent,
       :icmsn_percent, margins: {},
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
