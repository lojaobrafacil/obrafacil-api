class ApiPartner::PartnersSerializer < ActiveModel::Serializer
  attributes :id, :name, :register, :site, :address, :phone,
             :email, :avatar, :projects, :aboutme, :instagram

  def projects
    object.projects.order(project_date: :desc).limit(4).map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(ApiPartner::PartnerProjectSerializer.new(u)).serializable_hash } rescue []
  end

  def phone
    ActiveModelSerializers::Adapter.configured_adapter.new(ApiPartner::PhoneSerializer.new(object.primary_phone)).serializable_hash
  end

  def email
    ActiveModelSerializers::Adapter.configured_adapter.new(ApiPartner::EmailSerializer.new(object.primary_email)).serializable_hash
  end

  def address
    ActiveModelSerializers::Adapter.configured_adapter.new(ApiPartner::AddressSerializer.new(object.addresses.first)).serializable_hash if !object.addresses.empty?
  end
end
