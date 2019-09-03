class Api::PartnerSerializer < ActiveModel::Serializer
  attributes :id, :name, :federal_registration, :state_registration, :kind, :status,
             :started_date, :renewal_date, :description, :origin, :percent, :agency, :account,
             :favored, :bank_id, :bank_name, :partner_group_id, :partner_group_name, :ocupation,
             :addresses, :phones, :emails, :cash_redemption, :favored_federal_registration,
             :register, :site, :instagram, :avatar, :project_image, :aboutme, :updated_at, :created_at, :deleted_at

  has_one :coupon
  has_one :created_by
  has_one :deleted_by

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

  def created_by
    object.created_by.as_json(only: [:id, :name])
  end

  def deleted_by
    object.deleted_by.as_json(only: [:id, :name])
  end
end
