class Api::EmployeeSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :federal_registration, :state_registration, :active,
             :birth_date, :renewal_date, :admin, :change_partners, :change_clients, :change_suppliers,
             :change_cashiers, :generate_nfe, :import_xml, :change_products, :order_client, :order_devolution,
             :order_cost, :order_done, :order_price_reduce, :order_inactive, :order_creation, :limit_margin,
             :change_coupon, :change_campain, :change_highlight, :change_bank, :change_carrier, :change_employee,
             :commission_percent, :description, :street, :number, :complement, :neighborhood, :zipcode,
             :phone, :celphone, :updated_at, :created_at

  has_one :city

  def phone
    object.formatted_phone
  end

  def celphone
    object.formatted_celphone
  end
end
