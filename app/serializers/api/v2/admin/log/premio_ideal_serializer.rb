class Api::V2::Admin::Log::PremioIdealSerializer < ActiveModel::Serializer
  attributes :id, :status, :error, :body
  has_one :partner
end
