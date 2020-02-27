class Api::PartnerProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :project_date, :description, :environment,
             :status, :status_rmk, :products, :city, :partner_id, :images,
             :metadata, :created_at, :updated_at
end
