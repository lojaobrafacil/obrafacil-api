class Api::HighlightSerializer < ActiveModel::Serializer
  attributes :id, :title, :subtitle, :image, :secondaryImage, :metadata, :starts_in, :expires_at,
             :status, :kind, :position, :link, :created_at, :updated_at
end
