class ApiPartner::CampainSerializer < ActiveModel::Serializer
  attributes :title_1, :title_2, :content_1, :content_2, :content_3,
             :image_1, :image_2, :image_3, :link
end
