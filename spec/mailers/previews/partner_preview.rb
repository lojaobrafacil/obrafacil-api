class PartnerPreview < ActionMailer::Preview
  def new_indication
    @partner = Partner.find_or_create_by(federal_registration: "44576403877")
    @partner.update(
      name: "Arthur Moura",
      kind: 0,
      birthday: "13/07/1995",
      renewal_date: Time.new() + (1..10).to_a.sample.year,
      origin: 0,
      status: 1,
      favored: "Arthur Moura",
      favored_federal_registration: "44576403877",
      reset_password_token: Devise.friendly_token(120),
      reset_password_sent_at: Time.now,
    )
    @email = @partner.emails.find_or_create_by(
      email: "arthurjm95@gmail.com",
    )
    @email.update(contact: "Arthur Moura",
                  primary: true)
    PartnerMailer.new_indication(@partner, "NomeCliente")
  end

  def request_access
    @partner = Partner.find_or_create_by(federal_registration: "44576403877")
    @partner.update(
      name: "Arthur Moura",
      kind: 0,
      birthday: "13/07/1995",
      renewal_date: Time.new() + (1..10).to_a.sample.year,
      origin: 0,
      status: 1,
      favored: "Arthur Moura",
      favored_federal_registration: "44576403877",
      reset_password_token: Devise.friendly_token(120),
      reset_password_sent_at: Time.now,
    )
    @email = @partner.emails.find_or_create_by(
      email: "arthurjm95@gmail.com",
    )
    @email.update(contact: "Arthur Moura",
                  primary: true)
    PartnerMailer.request_access(@partner)
  end

  def first_access
    @partner = Partner.find_or_create_by(federal_registration: "44576403877")
    @partner.update(
      name: "Arthur Moura",
      kind: 0,
      birthday: "13/07/1995",
      renewal_date: Time.new() + (1..10).to_a.sample.year,
      origin: 0,
      status: 1,
      favored: "Arthur Moura",
      favored_federal_registration: "44576403877",
      reset_password_token: Devise.friendly_token(120),
      reset_password_sent_at: Time.now,
    )
    @email = @partner.emails.find_or_create_by(
      email: "arthurjm95@gmail.com",
    )
    @email.update(contact: "Arthur Moura",
                  primary: true)
    PartnerMailer.first_access(@partner)
  end

  def forgot_password_instruction
    @partner = Partner.find_or_create_by(federal_registration: "44576403877")
    @partner.update(
      name: "Arthur Moura",
      kind: 0,
      birthday: "13/07/1995",
      renewal_date: Time.new() + (1..10).to_a.sample.year,
      origin: 0,
      status: 1,
      favored: "Arthur Moura",
      favored_federal_registration: "44576403877",
      reset_password_token: Devise.friendly_token(120),
      reset_password_sent_at: Time.now,
    )
    @email = @partner.emails.find_or_create_by(
      email: "arthurjm95@gmail.com",
    )
    @email.update(contact: "Arthur Moura",
                  primary: true)
    PartnerMailer.forgot_password_instruction(@partner, SecureRandom.alphanumeric(10))
  end

  def client_needs_more_information
    @partner = Partner.find_or_create_by(federal_registration: "44576403877")
    @partner.update(
      name: "Arthur Moura",
      kind: 0,
      birthday: "13/07/1995",
      renewal_date: Time.new() + (1..10).to_a.sample.year,
      origin: 0,
      status: 1,
      favored: "Arthur Moura",
      favored_federal_registration: "44576403877",
      reset_password_token: Devise.friendly_token(120),
      reset_password_sent_at: Time.now,
    )
    @email = @partner.emails.find_or_create_by(
      email: "arthurjm95@gmail.com",
    )
    @email.update(contact: "Arthur Moura",
                  primary: true)
    PartnerMailer.client_needs_more_information(@partner, { name: "Arthur", email: "client@client.com", subject: "subject", message: "message" })
  end
end
