class PartnerMailer < ApplicationMailer
  def new_indication(partner, client_name)
    @partner = partner
    @first_name = @partner.name.split.first
    @last_name = @partner.name.split.last
    @partner_name = "#{@first_name} #{@last_name}" rescue @partner.name
    @client_name = client_name
    @infos = "#{@partner.id};#{@partner.name};#{@partner.primary_email.id};#{@partner.primary_email.email};#{@partner.primary_phone.id};#{@partner.primary_phone.phone.remove("+55")}"
    @url = "#{ENV["WEB_ENDPOINT"]}/cadastrar?info=#{@infos}"
    @web_endpoint = ENV["WEB_ENDPOINT"]
    mail(
      to: "#{@partner_name}<#{@partner.primary_email.email}>",
      subject: "Programa Mais Descontos: Você Foi Indicado!",
    )
  end

  def request_access(partner)
    @partner = partner
    @first_name = @partner.name.split.first
    @last_name = @partner.name.split.last
    @partner_name = "#{@first_name} #{@last_name}" rescue @partner.name
    @url = ENV["WEB_ENDPOINT"]
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
    @url = ENV["WEB_ENDPOINT"]
    mail(
      to: "#{@partner_name}<#{@partner.primary_email.email}>",
      subject: "Programa Mais Descontos: APROVADO!",
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
