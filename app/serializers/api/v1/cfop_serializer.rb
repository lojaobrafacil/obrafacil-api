class Api::V1::CfopSerializer < ActiveModel::Serializer
  attributes :id, :code, :description
end
