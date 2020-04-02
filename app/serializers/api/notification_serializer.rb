class Api::NotificationSerializer < ActiveModel::Serializer
  attributes :id, :title, :title, :target_id, :target_type,
             :notified_id, :notified_type, :viewed, :created_at
end
