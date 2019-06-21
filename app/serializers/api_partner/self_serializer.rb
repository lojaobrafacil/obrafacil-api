class ApiPartner::SelfSerializer < ActiveModel::Serializer
  attributes :id, :name, :federal_registration, :state_registration, :agency, :account,
             :favored, :favored_federal_registration, :bank_name, :register, :site,
             :addresses, :phones, :emails, :commissions

  has_one :coupon

  def bank_name
    object.bank ? object.bank.name : nil
  end

  def phones
    object.phones.order(primary: :desc).map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(ApiPartner::PhoneSerializer.new(u)).serializable_hash }
  end

  def emails
    object.emails.order(primary: :desc).map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(ApiPartner::EmailSerializer.new(u)).serializable_hash }
  end

  def addresses
    object.addresses.map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(ApiPartner::AddressSerializer.new(u)).serializable_hash }
  end

  def commissions
    object.commissions.map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(ApiPartner::CommissionSerializer.new(u)).serializable_hash }
  end
end
