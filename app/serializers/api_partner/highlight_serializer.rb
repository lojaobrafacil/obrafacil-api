class ApiPartner::HighlightSerializer < ActiveModel::Serializer
  attributes :id, :title, :subtitle, :image, :metadata, :starts_in, :expires_at,
             :status, :kind, :position, :link, :images, :created_at, :updated_at

  def image
    object.image.url.nil? && object.images&.first ? object.images.first.attachment.as_json : object.image.as_json
  end
end
