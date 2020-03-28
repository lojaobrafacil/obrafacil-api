class Api::Log::SendSmsWorkerSerializer < ActiveModel::Serializer
  attributes :id, :name, :content, :status, :started_at, :finished_at
end
