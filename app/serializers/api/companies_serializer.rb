class Api::CompaniesSerializer < ActiveModel::Serializer
  attributes :id, :name, :fantasy_name, :federal_registration, :state_registration
end
