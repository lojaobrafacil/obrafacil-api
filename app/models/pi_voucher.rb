class PiVoucher < ApplicationRecord
  include ActionView::Helpers::NumberHelper
  belongs_to :company, optional: true
  belongs_to :partner
  validates_presence_of :expiration_date, :value, :status
  after_initialize :default_values

  enum status: [:used, :active, :inactive]

  mount_uploader :attachment, ReportFileUploader

  after_create :generate_pdf

  def value_br
    number_to_currency(self.value, :unit => "R$ ", :separator => ",", :delimiter => ".")
  end

  def generate_pdf
    PdfPiVoucher.new(Rails.root.join("public/voucher_#{self.id}.pdf"), self).render
    file = File.new(Rails.root.join("public/voucher_#{self.id}.pdf"))
    self.update(attachment: file)
    File.delete(Rails.root.join("public/voucher_#{self.id}.pdf"))
  end

  private

  def default_values
    self.expiration_date = Time.now + 30.days
  end
end
