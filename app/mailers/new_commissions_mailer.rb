class NewCommissionsMailer < ApplicationMailer
  def sample_email(partner)
    @partner = partner
    @name = @partner.name.split(" ")[0]
    mail(to: @partner.primary_email.email, subject: "ObraFacil: Temos atualização das suas pontuações!")
  end
end
