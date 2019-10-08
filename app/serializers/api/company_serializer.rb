class Api::CompanySerializer < ActiveModel::Serializer
  attributes :id, :name, :fantasy_name, :federal_registration, :state_registration,
             :birth_date, :tax_regime, :description, :invoice_sale, :invoice_return,
             :pis_percent, :confins_percent, :icmsn_percent, :margins,
             :updated_at, :created_at

  has_many :addresses
  has_many :phones
  has_many :emails

  def phones
    object.phones.order(primary: :desc).map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(Api::PhoneSerializer.new(u)).serializable_hash }
  end

  def emails
    object.emails.order(primary: :desc).map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(Api::EmailSerializer.new(u)).serializable_hash }
  end

  def addresses
    object.addresses.map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(Api::AddressSerializer.new(u)).serializable_hash }
  end

  def margins
    object.margins || {}
  end
end
