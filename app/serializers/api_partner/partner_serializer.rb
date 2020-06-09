class ApiPartner::PartnerSerializer < ActiveModel::Serializer
  attributes :id, :name, :register, :site, :addresses, :phones,
             :emails, :avatar

  def phones
    object.phones.order(primary: :desc).map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(ApiPartner::PhoneSerializer.new(u)).serializable_hash }
  end

  def emails
    object.emails.order(primary: :desc).map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(ApiPartner::EmailSerializer.new(u)).serializable_hash }
  end

  def addresses
    object.addresses.map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(ApiPartner::AddressSerializer.new(u)).serializable_hash }
  end
end
