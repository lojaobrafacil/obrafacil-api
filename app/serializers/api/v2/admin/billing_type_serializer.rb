class Api::V1::BillingTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :updated_at, :created_at
end
