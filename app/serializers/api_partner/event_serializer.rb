class ApiPartner::EventSerializer < ActiveModel::Serializer
  attributes :id, :title, :subtitle, :image, :images, :secondaryImage, :metadata,
             :starts_in, :expires_at, :status, :link, :created_at, :updated_at

  def image
    object.image.url.nil? && object.images&.first ? object.images.first.attachment.as_json : object.image.as_json
  end
end
