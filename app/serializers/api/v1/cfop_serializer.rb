class Api::V1::CfopSerializer < ActiveModel::Serializer
  attributes :id, :code, :description, :updated_at, :created_at
end
