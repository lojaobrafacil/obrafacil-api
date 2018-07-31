class Api::V2::Admin::BillingTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :updated_at, :created_at
end
