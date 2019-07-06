class PartnerMailer < ApplicationMailer
  def new_partner(partner)
    @partner = partner
    mail(to: "relacionamento@lojaobrafacil.com.br", subject: "ObraFacil: Novo Parceiro!")
  end

  def new_indication(partner)
    @partner = partner
    mail(to: "relacionamento@lojaobrafacil.com.br", subject: "ObraFacil: Nova indicação!")
  end

  def forgot_password_instruction(partner)
    @partner = partner
    @url = "#{ENV["WEB_ENDPOINT"]}/redefinir-senha?t=#{@partner.reset_password_token}&c=#{Base64.encode64 @partner.federal_registration}"
    mail(to: @partner.primary_email.email, subject: "Programa Mais Descontos: Esqueceu sua senha!")
  end
end
