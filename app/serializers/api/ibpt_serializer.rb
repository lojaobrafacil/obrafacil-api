class Api::IbptSerializer < ActiveModel::Serializer
  attributes :id, :code, :description, :national_aliquota, :international_aliquota,
             :updated_at, :created_at
end
