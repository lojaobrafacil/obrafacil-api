class Api::ApiSerializer < ActiveModel::Serializer
  attributes :id, :name, :federal_registration, :active, :kind,
             :access_id, :access_key, :updated_at, :created_at
end
