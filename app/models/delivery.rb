class Delivery < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :city, optional: true
  belongs_to :driver, class_name: "Employee", foreign_key: "driver_id"
  belongs_to :checker, class_name: "Employee", foreign_key: "checker_id"
  before_validation :validate_phone
  enum status: [:approved, :separated, :check, :nota_emitida, :"saiu para entrega", :"saiu para deposito", :"FINALIZADO"]

  def validate_phone
    if !self.phone.to_s.empty?
      number = self.phone.gsub(/[^0-9+]\s*/, "").gsub(/\+55\s*/, "")
      msgs ||= "Formato inválido." if number.size > 15 || number.size < 9
      msgs ||= "Por favor, informar um número de celular válido incluindo o dígito 9." if number.size == 11 && number[2, 1] != "9"
      number = "+55#{number}" unless number.include? "+55"
      msgs.nil? ? self.phone = number : errors.add(:phone, msgs)
    end
  end
end
