class Api::CampainSerializer < ActiveModel::Serializer
  attributes :id, :title, :subtitle, :metadata, :image, :status,
             :kind, :position, :link, :created_at, :updated_at
end
