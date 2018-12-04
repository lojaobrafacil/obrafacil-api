class Phone < ApplicationRecord
  belongs_to :phone_type
  belongs_to :phonable, polymorphic: true
  validates :phone, format: { with: /\A\+\d{1,2}?\d{2}\d{4,5}\d{4}\z/, message: "can't be blank. format: +XXXXXXXXXXXXX"}
  before_validation :format_phone

  def format_phone

    if self.phone.nil?
      errors.add(:phone, "can't be blank")
      abort
    end

    number = self.phone.gsub(/[^0-9+]\s*/, '').gsub(/\+55\s*/, '')

    if number.size > 15 || number.size < 8
      msgs ||= 'Formato inválido.'
    end

    if number.size == 11 && number[2,1] != '9'
      msgs ||= 'Por favor, informar um número de celular válido incluindo o dígito 9.'
    end

    unless number.include? '+55'
      number = "+55#{number}"
    end

    msgs.nil? ? self.phone = number : errors.add(:phone, msgs)
  end
end
