class ApiPartner::HighlightSerializer < ActiveModel::Serializer
  attributes :id, :title, :subtitle, :image, :metadata, :starts_in, :expires_at,
             :status, :kind, :position, :link, :images, :created_at, :updated_at
end
