class Api::V2::Admin::PricePercentageSerializer < ActiveModel::Serializer
  attributes :id, :margin, :kind, :company_id, :updated_at, :created_at
end
