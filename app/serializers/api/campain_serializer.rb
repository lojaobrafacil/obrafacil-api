class Api::CampainSerializer < ActiveModel::Serializer
  attributes :id, :title_1, :title_2, :content_1, :content_2, :content_3,
             :image_1, :image_2, :image_3, :expires_at, :starts_in,
             :status, :kind, :position, :link, :created_at, :updated_at
end
