class Api::V1::CommissionSerializer < ActiveModel::Serializer
  attributes :id, :order_id, :order_date, :client_name, :order_price, :return_price
  :points, :percent_date, :percent, :percent_value, :sent_date, :partner_id

  def percent_value
    object.percent ? (object.order_price - object.return_price)*object.percent : 0
  end
end