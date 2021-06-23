class EmployeeMailer < ApplicationMailer
  def new_partner(partner)
    @partner = partner
    mail(
      to: ["relacionamento@lojaobrafacil.com.br", "admrelacionamento@lojaobrafacil.com.br"],
      subject: "ObraFacil: Novo Parceiro!",
    )
  end

  def new_partner_indication(partner)
    @partner = partner
    mail(
      to: ["relacionamento@lojaobrafacil.com.br", "admrelacionamento@lojaobrafacil.com.br"],
      subject: "ObraFacil: Nova indicação!",
    )
  end

  def new_contact(contact)
    @contact = contact
    mail(
      reply_to: @contact[:email] ? @contact[:email] : nil,
      to: ["relacionamento@lojaobrafacil.com.br", "admrelacionamento@lojaobrafacil.com.br"],
      subject: "ObraFacil: Nova contato! #{@contact[:subject] ? "- #{@contact[:subject]}" : ""}",
    )
  end
end
