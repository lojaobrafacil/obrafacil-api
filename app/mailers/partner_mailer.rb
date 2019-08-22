class PartnerMailer < ApplicationMailer
  def welcome(partner)
    @partner = partner
    mail(
      to: "relacionamento@lojaobrafacil.com.br",
      bcc: BCC_MAIL,
      subject: "ObraFacil: Novo Parceiro!",
    )
  end

  def forgot_password_instruction(partner)
    @partner = partner
    @partner_name = @partner.primary_email.contact
    @url = "#{ENV["WEB_ENDPOINT"]}/redefinir-senha?t=#{@partner.reset_password_token}&c=#{Base64.encode64 @partner.federal_registration}"
    mail(
      to: @partner.primary_email.email,
      bcc: BCC_MAIL,
      subject: "Programa Mais Descontos: Esqueceu sua senha!",
    )
  end
end
