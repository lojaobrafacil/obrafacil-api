class Api::PartnerSerializer < ActiveModel::Serializer
  attributes :id, :name, :federal_registration, :state_registration, :kind, :active,
             :started_date, :renewal_date, :description, :origin, :percent, :agency, :account,
             :favored, :bank_id, :bank_name, :partner_group_id, :partner_group_name, :ocupation,
             :discount3, :discount5, :addresses, :phones, :emails, :discount8, :cash_redemption,
             :updated_at, :created_at

  has_one :user
  has_one :partner_group

  def bank_name
    object.bank ? object.bank.name : nil
  end

  def partner_group_name
    object.partner_group ? object.partner_group.name : nil
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
