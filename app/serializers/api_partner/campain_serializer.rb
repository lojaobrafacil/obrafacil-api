class ApiPartner::CampainSerializer < ActiveModel::Serializer
  attributes :title, :subtitle, :metadata, :image, :position
end
