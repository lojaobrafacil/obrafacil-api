class Api::V2::Admin::CarrierSerializer < ActiveModel::Serializer
  attributes :id, :name, :federal_registration, :state_registration, :kind, :description,
  :active, :updated_at, :created_at
end
