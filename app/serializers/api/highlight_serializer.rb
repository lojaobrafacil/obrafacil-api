class Api::HighlightSerializer < ActiveModel::Serializer
  attributes :id, :title_1, :content_1, :image_1, :expires_at, :starts_in,
             :status, :kind, :position, :link, :created_at, :updated_at
end
