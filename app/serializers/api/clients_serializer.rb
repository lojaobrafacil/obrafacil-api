class Api::ClientsSerializer < ActiveModel::Serializer
  attributes :id, :name, :federal_registration, :state_registration, :status, :description
end
