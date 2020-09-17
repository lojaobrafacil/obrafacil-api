class ApiPartner::PartnerProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :project_date, :highlight_image, :content, :environment,
             :products, :city, :images, :metadata
  belongs_to :partner

  def highlight_image
    object.highlight_image&.attachment_url
  end

  def partner
    object.partner.as_json(only: [:id, :name, :site, :aboutme, :instagram, :phones, :emails, :addresses, :avatar])
  end
end
