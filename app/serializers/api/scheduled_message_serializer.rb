class Api::ScheduledMessageSerializer < ActiveModel::Serializer
  attributes :id, :name, :text, :status, :receiver_type, :frequency_type,
             :frequency, :starts_at, :finished_at, :last_execution,
             :next_execution, :repeat, :receiver_ids
  has_one :created_by

  def created_by
    object.created_by.as_json(only: [:id, :name])
  end
end
