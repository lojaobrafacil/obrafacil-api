class PiVoucher < ApplicationRecord
  include ActionView::Helpers::NumberHelper
  belongs_to :company, optional: true
  belongs_to :partner
  validates_presence_of :expiration_date, :value, :status
  before_create :default_values
  before_validation :validate_status
  after_create :generate_pdf
  after_save :attachment_remove_if_inactive!, if: Proc.new { |pi_voucher| self.attachment.remove! if pi_voucher.inactive? }

  enum status: [:used, :active, :inactive]

  mount_uploader :attachment, VoucherFileUploader

  def validate_status
    if self.id
      @old = PiVoucher.find(self.id)
      case @old.status
      when "active"
        if self.status == "used"
          errors.add(:used_at, I18n.t("models.pi_voucher.errors.company_id")) unless self.company_id
          errors.add(:used_at, I18n.t("models.pi_voucher.errors.used_at")) unless self.used_at
        end
        if self.status == "inactive"
          errors.add(:status, I18n.t("models.pi_voucher.errors.status.received_at")) unless self.received_at.nil?
        end
      when "used"
        errors.add(:status, I18n.t("models.pi_voucher.errors.status.used_to_inactive")) if self.status == "inactive"
        errors.add(:status, I18n.t("models.pi_voucher.errors.status.used_to_active")) if self.status == "active"
        errors.add(:status, I18n.t("models.pi_voucher.errors.status.already_used")) if self.status == "used"
      when "inactive"
        errors.add(:status, I18n.t("models.pi_voucher.errors.status.inactive"))
      end
      if @old.received_at
        errors.add(:base, I18n.t("models.pi_voucher.errors.received_at")) if @old.received_at != self.received_at
      end
    end
  end

  def value_br
    number_to_currency(self.value, :unit => "R$ ", :separator => ",", :delimiter => ".")
  end

  def generate_pdf
    PiVouchers::PdfService.new(self.id).call ? true : errors.add(:base, I18n.t("models.pi_voucher.errors.pdf"))
  end

  private

  def default_values
    self.expiration_date = Time.now + 30.days
  end
end
