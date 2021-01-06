class Order < TemplateOrder
  validates :buyer_id, presence: false, numericality: { only_integer: true }, allow_nil: true, allow_blank: true
  validates :buyer_type, presence: false, inclusion: { in: ["Client"], message: "deve ser um Cliente" }, allow_nil: true, allow_blank: true
  belongs_to :cashier, optional: true
  belongs_to :partner, optional: true
  belongs_to :payment_term
  has_one :commission
  has_one :delivery
  enum status: [:budget, :to_pay, :paid, :deleted]
  before_validation :state_machine_to_status
  before_validation :default_values

  def sum_itens_price
    122
  end

  def sync_commission
    cm = commission
    if cm.nil? && !partner.nil? && !billing_at.nil?
      create_commission(commission_params)
    elsif !partner.nil? && !billing_at.nil?
      cm.update(commission_params)
    else
      cm.destroy if cm.sent_date.nil?
    end
  end

  def commission_params
    {
      partner: partner,
      order_date: created_at,
      order_price: sum_itens_price,
      client_name: client ? client.name : "",
      points: 2,
      percent: 2,
      percent_date: Time.now,
      return_price: "",
    }
  end

  def default_values
    self.status = 0 if self.status.to_s.empty?
  end

  def state_machine_to_status
    case status_in_database
    when "budget"
      # nao precisa de cliente
      # precisa de funcionario, margem, empresa, 1 produto
      # errors.add(:status, "Orcamento nao pode ir para Pago") if status == "paid"
    when "to_pay"
      !buyer_id && !buyer_type
      errors.add(:buyer, "é obrigatorio")
      # precisa de cliente (caso nao seja consumidor final)
      # precisa de funcionario, margem, empresa, 1 produto
      # nao pode voltar para orcamento?
      errors.add(:status, "A pagar nao pode ir para Orcamento") if status == "budget"
    when "paid"
      sync_commission if partner_id
      # precisa vir de a pagar
      # pode alterar cliente (nao pode voltar para consumidor final), sem alterar tabela
      errors.add(:status, "Pago nao pode ser atualizado") if status_changed?
    when "deleted"
      # morreu
      errors.add(:status, "Deletado nao pode ser atualizado")
    else
      nil
    end
  end
end
