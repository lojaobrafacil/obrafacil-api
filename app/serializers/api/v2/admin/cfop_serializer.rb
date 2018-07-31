class Api::V2::Admin::CfopSerializer < ActiveModel::Serializer
  attributes :id, :code, :description, :updated_at, :created_at
end
