class Api::PartnerProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :project_date, :content, :environment,
             :status, :status_rmk, :products, :city, :partner, :images,
             :metadata, :created_at, :updated_at

  def partner
    {
      id: object.partner.id,
      name: object.partner.name,
      searcher: object.partner.searcher.titleize,
    } if object.partner
  end
end
