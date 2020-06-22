class ApiPartner::EventSerializer < ActiveModel::Serializer
  attributes :id, :title, :subtitle, :image, :secondaryImage, :metadata, :starts_in, :expires_at,
             :status, :link, :created_at, :updated_at
end
