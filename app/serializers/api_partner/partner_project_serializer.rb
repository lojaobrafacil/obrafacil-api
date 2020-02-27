class ApiPartner::PartnerProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :project_date, :description, :environment,
             :products, :city, :images
  belongs_to :partner
end
