class ApiPartner::PartnerProjectsSerializer < ActiveModel::Serializer
  attributes :id, :name, :highlight_image, :metadata
  belongs_to :partner

  def partner
    { id: object.partner_id, name: object.partner.name }
  end

  def highlight_image
    object.highlight_image&.attachment_url
  end
end
