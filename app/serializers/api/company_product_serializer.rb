class Api::CompanyProductSerializer < ActiveModel::Serializer
  attributes :id, :company_id, :company_name, :stock, :stock_min, :stock_max,
             :cost, :discount, :st, :margin, :updated_at, :created_at

  def company_name
    object.company ? object.company.name : nil
  end
end
