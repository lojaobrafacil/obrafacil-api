class EmployeeMailer < ApplicationMailer
  def new_partner(partner)
    @partner = partner
    mail(
      to: "relacionamento@lojaobrafacil.com.br",
      bcc: BCC_MAIL,
      subject: "ObraFacil: Novo Parceiro!",
    )
  end

  def new_partner_indication(partner)
    @partner = partner
    mail(
      to: "relacionamento@lojaobrafacil.com.br",
      bcc: BCC_MAIL,
      subject: "ObraFacil: Nova indicação!",
    )
  end
end
