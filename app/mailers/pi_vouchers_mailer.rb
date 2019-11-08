class PiVouchersMailer < ApplicationMailer
  require "open-uri"

  def send_to_partner(pi_voucher)
    @pi_voucher = pi_voucher
    @partner = @pi_voucher.partner
    @name = @partner.name
    @pdf = open(@pi_voucher.attachment_url).read
    attachments["voucher_#{@name}.pdf"] = @pdf
    mail(
      to: "#{@name}<#{@partner.primary_email.email}>",
      subject: "ObraFacil: Seu voucher esta disponível!",
      reply_to: "relacionamento@lojaobrafacil.com.br",
    )
  end
end
