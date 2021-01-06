class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order
  belongs_to :environment, optional: true
  belongs_to :checker, :class_name => "Employee", :foreign_key => "checker_employee_id", optional: true
  belongs_to :output_company, :class_name => "Company", :foreign_key => "output_company_id", optional: true
  before_save :default_values

  def default_values
    self.description ||= self.product.name
  end
end
