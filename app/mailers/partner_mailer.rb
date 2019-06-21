class PartnerMailer < ApplicationMailer
  def new_partner(partner)
    @partner = partner
    mail(to: "relacionamento@lojaobrafacil.com.br", subject: "ObraFacil: Novo Parceiro!")
  end
end
