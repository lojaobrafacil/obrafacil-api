class ApiPartner::HighlightSerializer < ActiveModel::Serializer
  attributes :id, :title, :subtitle, :image, :metadata, :starts_in,
             :status, :kind, :position, :created_at, :updated_at
end
