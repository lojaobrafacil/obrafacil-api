class Devolution < TemplateOrder
  validates :buyer_id, presence: true, numericality: { only_integer: true }
  validates :buyer_type, presence: true, inclusion: { in: ["Client"], message: "deve ser um Cliente" }
  belongs_to :cashier, optional: true
  enum status: [:budget, :to_pay, :paid, :deleted]
end
