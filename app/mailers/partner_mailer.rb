class PartnerMailer < ApplicationMailer
  def new_partner(partner)
    @partner = partner
    mail(to: "arthurjm95@gmail.com", subject: "ObraFacil: Novo Parceiro!")
  end
end
