class Api::V1::CompanyProductSerializer < ActiveModel::Serializer
  attributes :id, :company_id, :company_name, :stock, :stock_min, :stock_max,
  :updated_at, :created_at

  def company_name
    object.company.name
  end
end
