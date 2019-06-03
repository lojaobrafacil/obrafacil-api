class Api::Log::SmsWorkerSerializer < ActiveModel::Serializer
  attributes :id, :name, :content, :status, :started_at, :finished_at
end
