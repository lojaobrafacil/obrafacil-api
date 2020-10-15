class ApiPartner::PartnerSerializer < ActiveModel::Serializer
  attributes :id, :name, :register, :aboutme, :site, :addresses, :phones,
             :emails, :avatar, :instagram, :phone, :email, :address

  def phones
    object.phones.order(primary: :desc).map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(ApiPartner::PhoneSerializer.new(u)).serializable_hash }
  end

  def emails
    object.emails.order(primary: :desc).map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(ApiPartner::EmailSerializer.new(u)).serializable_hash }
  end

  def addresses
    object.addresses.map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(ApiPartner::AddressSerializer.new(u)).serializable_hash }
  end

  def phone
    phones[0]
  end

  def email
    emails[0]
  end

  def address
    addresses[0]
  end
end
