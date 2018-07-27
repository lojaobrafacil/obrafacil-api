class Api::V2::Admin::PaymentMethodSerializer < ActiveModel::Serializer
  attributes :id, :name, :updated_at, :created_at
end
