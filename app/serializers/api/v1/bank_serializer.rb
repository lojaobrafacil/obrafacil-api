class Api::V1::BankSerializer < ActiveModel::Serializer
  attributes :id, :code, :name, :slug, :description, :updated_at, :created_at
end
