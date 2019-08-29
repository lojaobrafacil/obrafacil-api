class Api::ClientSerializer < ActiveModel::Serializer
  attributes :id, :name, :federal_registration, :state_registration, :international_registration,
             :kind, :status, :birthday, :renewal_date, :tax_regime, :description, :order_description,
             :limit, :limit_pricing_percentage, :billing_type_id, :billing_type_name, :addresses, :phones, :emails,
             :created_at, :updated_at

  def billing_type_name
    object.billing_type ? object.billing_type.name : nil
  end

  def phones
    object.phones.order(primary: :desc).map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(Api::PhoneSerializer.new(u)).serializable_hash }
  end

  def emails
    object.emails.order(primary: :desc).map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(Api::EmailSerializer.new(u)).serializable_hash }
  end

  def addresses
    object.addresses.map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(Api::AddressSerializer.new(u)).serializable_hash }
  end
end
