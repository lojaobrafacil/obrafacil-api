class Api::PartnersSerializer < ActiveModel::Serializer
  attributes :id, :name, :federal_registration, :state_registration, :status,
             :description, :cash_redemption, :partner_group, :created_at
end
