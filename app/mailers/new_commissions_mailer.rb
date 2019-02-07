class NewCommissionsMailer < ApplicationMailer
  def sample_email(partner)
    @partner = partner
    mail(to: partner.email, subject: "Sample Email")
  end
end
