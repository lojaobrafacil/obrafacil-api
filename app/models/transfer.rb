class Transfer < TemplateOrder
  validates :buyer_id, presence: true, numericality: { only_integer: true }
  validates :buyer_type, presence: true, inclusion: { in: ["Company"], message: "deve ser uma Empresa" }
  belongs_to :billing_employee, class_name: "Employee", foreign_key: "billing_employee_id"
  enum status: [:budget, :to_pay, :paid, :deleted]
end
