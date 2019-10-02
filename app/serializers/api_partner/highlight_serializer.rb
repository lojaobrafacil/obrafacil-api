class ApiPartner::HighlightSerializer < ActiveModel::Serializer
  attributes :title_1, :title_2, :content_1, :image_1, :link, :expires_at, :starts_in
end
