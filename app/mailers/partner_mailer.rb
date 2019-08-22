class PartnerMailer < ApplicationMailer
  def request_access(partner)
    @partner = partner
    @first_name = @partner.name.split.first
    @last_name = @partner.name.split.last
    @partner_name = "#{@first_name} #{@last_name}" rescue @partner.name
    mail(
      to: "#{@partner_name}<#{@partner.primary_email.email}>",
      subject: "Programa Mais Descontos: Bem vindo!",
    )
  end

  def first_access(partner)
    @partner = partner
    @first_name = @partner.name.split.first
    @last_name = @partner.name.split.last
    @partner_name = "#{@first_name} #{@last_name}" rescue @partner.name
    @coupon_code = @partner.coupon.code
    mail(
      to: "#{@partner_name}<#{@partner.primary_email.email}>",
      subject: "Programa Mais Descontos: Bem vindo!",
    )
  end

  def forgot_password_instruction(partner)
    @partner = partner
    @partner_name = @partner.primary_email.contact
    @url = "#{ENV["WEB_ENDPOINT"]}/redefinir-senha?t=#{@partner.reset_password_token}&c=#{Base64.encode64 @partner.federal_registration}"
    mail(
      to: "#{@partner_name}<#{@partner.primary_email.email}>",
      subject: "Programa Mais Descontos: Esqueceu sua senha!",
    )
  end
end
