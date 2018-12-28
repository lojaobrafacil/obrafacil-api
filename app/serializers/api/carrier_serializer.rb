class Api::CarrierSerializer < ActiveModel::Serializer
  attributes :id, :name, :federal_registration, :state_registration, :kind, :description,
             :active, :updated_at, :created_at
end
