class Partner::SelfSerializer < ActiveModel::Serializer
  attributes :id, :name, :federal_registration, :state_registration, :agency, :account,
             :favored, :favored_federal_registration, :bank_name, :discount5, :addresses, :phones, :emails

  def bank_name
    object.bank ? object.bank.name : nil
  end

  def phones
    object.phones.order(primary: :desc).map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(Partner::PhoneSerializer.new(u)).serializable_hash }
  end

  def emails
    object.emails.order(primary: :desc).map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(Partner::EmailSerializer.new(u)).serializable_hash }
  end

  def addresses
    object.addresses.map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(Partner::AddressSerializer.new(u)).serializable_hash }
  end
end
