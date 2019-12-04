class Api::OrdersSerializer < ActiveModel::Serializer
  attributes :id, :kind, :exclusion_at, :billing_at,
             :company, :updated_at, :created_at

  def company
    Api::CompaniesSerializer.new(object.company)
  end
end
