class Api::OrderSerializer < ActiveModel::Serializer
  attributes :id, :status, :exclusion_at, :description, :discount, :freight, :billing_at,
             :buyer_id, :buyer_type, :company_id, :employee_id, :selected_margin,
             :discount_type, :status, :order_items, :created_at, :updated_at, :employee,
             :partner
  has_one :buyer
  has_one :cashier
  has_one :carrier

  def employee
    object.employee.as_json(only: [:id, :name, :active])
  end

  def partner
    object.partner.as_json(only: [:id, :name, :status])
  end

  def order_items
    object.order_items.order(:environment_id, :created_at).map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(Api::OrderItemsSerializer.new(u)).serializable_hash }
  end
end
