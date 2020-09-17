# Preview all emails at http://localhost:3000/rails/mailers/new_commissions
class NewCommissionsPreview < ActionMailer::Preview
  def sample_email
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
    NewCommissionsMailer.sample_email(@partner)
  end
end
