class Api::CommissionSerializer < ActiveModel::Serializer
  attributes :id, :partner_name, :order_id, :order_date, :client_name, :order_price,
             :return_price, :points, :percent_date, :percent, :percent_value, :sent_date,
             :partner_id, :comments, :created_at, :updated_at

  def partner_name
    object.partner.name
  end

  def percent_value
    object.percent ? ((object.order_price.to_f - object.return_price.to_f) * (object.percent.to_f / 100)).round : 0
  end
end
