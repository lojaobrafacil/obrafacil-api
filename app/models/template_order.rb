class TemplateOrder < ApplicationRecord
  self.table_name = "orders"
  belongs_to :buyer, polymorphic: true, optional: true
  belongs_to :employee
  belongs_to :carrier, optional: true
  belongs_to :company
  has_many :order_payments, dependent: :destroy
  validates_presence_of :type

  scope :billing_at_range, ->(start_date, end_date) { where(:billing_at => start_date..end_date) }
  scope :created_at_range, ->(start_date, end_date) { where(:created_at => start_date..end_date) }
end
