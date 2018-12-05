class Api::PaymentMethodSerializer < ActiveModel::Serializer
  attributes :id, :name, :updated_at, :created_at
end
