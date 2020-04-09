# Preview all emails at http://localhost:3000/rails/mailers/employee
class EmployeePreview < ActionMailer::Preview
  def new_partner_indication
    @partner = Partner.new(
      name: "Arthur Moura",
      federal_registration: "44576403877",
      kind: 0,
      birthday: "13/07/1995",
      renewal_date: Time.new() + (1..10).to_a.sample.year,
      bank: Bank.create(code: 999999, name: "banco 1"),
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
      phones_attributes: [{
        phone: "+5511972458510",
        contact: "Arthur Moura",
        primary: true,
      }],
      addresses_attributes: [{
        street: "rua bacairis",
        neighborhood: "Vila Formosa",
        zipcode: "03357050",
        number: "298",
        address_type_id: AddressType.create(name: "test"),
        city_id: City.create(name: "test", capital: true,
                             state: State.create(name: "test", acronym: "ts",
                                                 region: Region.create(name: "test"))),
      }],
    )
    EmployeeMailer.new_partner_indication(@partner)
  end

  def new_partner
    @partner = Partner.new(
      name: "Arthur Moura",
      federal_registration: "44576403877",
      kind: 0,
      birthday: "13/07/1995",
      renewal_date: Time.new() + (1..10).to_a.sample.year,
      bank: Bank.create(code: 999999, name: "banco 1"),
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
      phones_attributes: [{
        phone: "+5511972458510",
        contact: "Arthur Moura",
        primary: true,
      }],
      addresses_attributes: [{
        street: "rua bacairis",
        neighborhood: "Vila Formosa",
        zipcode: "03357050",
        number: "298",
        address_type_id: AddressType.create(name: "test"),
        city_id: City.create(name: "test", capital: true,
                             state_id: State.create(name: "test", acronym: "ts",
                                                    region_id: Region.create(name: "test").id).id).id,
      }],
    )
    EmployeeMailer.new_partner(@partner)
  end

  def new_contact
    EmployeeMailer.new_contact({
      name: "Arthur Moura",
      email: "arthurjm95@gmail.com",
      subject: "Subject",
      phone: "",
      message: "Message Message Message Message.",
    })
  end
end
