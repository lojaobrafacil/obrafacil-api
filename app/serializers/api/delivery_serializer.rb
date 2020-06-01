class Api::DeliverySerializer < ActiveModel::Serializer
  attributes :id, :order, :external_order_id, :recipient, :driver, :checker, :phone, :email,
             :checked_at, :freight, :status, :expected_delivery_in,
             :delivered_at, :left_delivery_at, :remark

  def driver
    Api::SimpleEmployeeSerializer.new(object.driver).as_json if object.driver_id
  end

  def checker
    Api::SimpleEmployeeSerializer.new(object.checker).as_json if object.checker_id
  end

  def phone
    object.formatted_phone
  end
end
