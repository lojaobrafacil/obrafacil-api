class ApiPartner::CampainSerializer < ActiveModel::Serializer
  attributes :title, :subtitle, :link, :metadata, :image, :position
end
