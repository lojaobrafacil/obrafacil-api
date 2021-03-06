

class PiVouchersPreview < ActionMailer::Preview
  def send_to_partner
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
    @pi_voucher = @partner.vouchers.find_or_create_by(value: 1000)
    PiVouchersMailer.send_to_partner(@pi_voucher)
  end
end
