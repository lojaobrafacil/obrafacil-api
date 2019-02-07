class Phone < ApplicationRecord
  belongs_to :phone_type
  belongs_to :phonable, polymorphic: true
  validates :phone, format: {with: /\A\+\d{1,2}?\d{2}\d{4,5}\d{4}\z/, message: "can't be blank. format: +XXXXXXXXXXXXX"}
  validates_uniqueness_of :primary, scope: [:phonable_id, :phonable_type], message: I18n.t("activerecord.models.errors.phone.attributes.primary"), if: Proc.new { |phone| phone.primary == true }
  before_validation :format_phone

  def format_phone
    if self.phone.nil?
      errors.add(:phone, "can't be blank")
      abort
    end

    number = self.phone.gsub(/[^0-9+]\s*/, "").gsub(/\+55\s*/, "")

    if number.size > 15 || number.size < 8
      msgs ||= "Formato inválido."
    end

    if number.size == 11 && number[2, 1] != "9"
      msgs ||= "Por favor, informar um número de celular válido incluindo o dígito 9."
    end

    unless number.include? "+55"
      number = "+55#{number}"
    end

    msgs.nil? ? self.phone = number : errors.add(:phone, msgs)
  end

  def formatted_phone(with_country = false)
    begin
      num = phone
      if num&.size == 13
        num = num.split("+55")[1].insert(0, "(").insert(3, ") ").insert(9, "-")
      elsif num&.size == 14
        num = num.split("+55")[1].insert(0, "(").insert(3, ") ").insert(10, "-")
      else
        num
      end
      with_country ? num.insert(0, "#{phone[0..2]} ") : num
    rescue
      phone
    end
  end
end
