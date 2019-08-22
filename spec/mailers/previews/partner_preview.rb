

class PartnerPreview < ActionMailer::Preview
  def forgot_password_instruction
    @partner = Partner.new(
      name: "Arthur Moura",
      federal_registration: "44576403877",
      kind: 0,
      started_date: "13/07/1995",
      renewal_date: Time.new() + (1..10).to_a.sample.year,
      origin: 0,
      status: 1,
      favored: "Arthur Moura",
      favored_federal_registration: "44576403877",
      reset_password_token: Devise.friendly_token(120),
      reset_password_sent_at: Time.now,
      emails_attributes: [{
        email: "arthurjm95@gmail.com",
        contact: "Arthur Moura",
        primary: true,
      }],
    )
    PartnerMailer.forgot_password_instruction(@partner)
  end
end
