class Api::NotificationsSerializer < ActiveModel::Serializer
  attributes :id, :title, :notified, :target
end
