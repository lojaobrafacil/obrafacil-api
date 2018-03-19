class Api::V1::UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :federal_registration, :kind, :created_at, :updated_at

  def admin
    object.admin?
  end
end
