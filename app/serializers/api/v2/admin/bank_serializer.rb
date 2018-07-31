class Api::V2::Admin::BankSerializer < ActiveModel::Serializer
  attributes :id, :code, :name, :slug, :description, :updated_at, :created_at  
end
