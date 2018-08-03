require 'faker'

namespace :dev do

  desc "Generate DB Faker"
  task generate_db: :environment do
    
    p "Criando Clientes "
    (1..20).to_a.each do
      c_email= Faker::Internet.email
      fr = Faker::Number.number(8)
      c = Client.create!(
      name: Faker::Name.name,
      federal_registration: fr,
      state_registration: Faker::Number.number(9),
      kind: [0,1].sample,
      birth_date: Faker::Date.birthday(18, 65),
      renewal_date: Time.new() + (1..10).to_a.sample.year,
      tax_regime: ["simple", "normal", "presumed"].sample,
      description: Faker::Lorem.paragraph(2),
      order_description: Faker::Lorem.sentence(3),
      limit: Faker::Number.decimal(4),
      user: User.create(email: fr+'@obrafacil.com', password:12345678, password_confirmation:12345678, federal_registration:fr))
    c.emails.create(email: c_email, email_type: EmailType.all.sample)
      c.phones.create(phone: Faker::PhoneNumber.phone_number, phone_type: PhoneType.all.sample)
      c.addresses.create(street: Faker::Address.street_name, zipcode: Faker::Number.number(8), address_type: AddressType.all.sample, city: City.all.sample)
    end
    p "Criando Clientes ....[OK]"

    p "Criando Parceiros "
    (1..20).to_a.each do
      p_email= Faker::Internet.email
      fr = Faker::Number.number(10)      
      p = Partner.create!(
        name: Faker::Name.name,
        federal_registration: fr,
        state_registration: Faker::Number.number(9),
        kind: [0,1].sample,
        started_date: Faker::Date.birthday(18, 65),
        renewal_date: Time.new() + (1..10).to_a.sample.year,
        origin: ["shop", "internet", "relationship"].sample,
        description: Faker::Lorem.paragraph(2),
        ocupation: Faker::Lorem.sentence(3),
        bank: Bank.all.sample,
        agency: Faker::Number.number(4),
        account: Faker::Number.number(6),
        favored: Faker::Name.name,
        user: User.create(email: fr+'@obrafacil.com', password:12345678, password_confirmation:12345678, federal_registration:fr))
        p.emails.create(email: p_email, email_type: EmailType.all.sample)
        p.phones.create(phone: Faker::PhoneNumber.phone_number, phone_type: PhoneType.all.sample)
        p.addresses.create(street: Faker::Address.street_name, zipcode: Faker::Number.number(8), address_type: AddressType.all.sample, city: City.all.sample)
    end
    p "Criando Parceiros ....[OK]"

    p "Criando Empregados "
    (1..20).to_a.each do
      fr = Faker::Number.number(8)
      e_email= fr.to_s + "@obrafacil.com"
      e = Employee.create!(
        name: Faker::Name.name,
        federal_registration: fr,
        state_registration: Faker::Number.number(9),
        birth_date: Faker::Date.birthday(18, 65),
        renewal_date: Time.new() + (1..10).to_a.sample.year,
        description: Faker::Lorem.paragraph(2),
        commission_percent: Faker::Number.decimal(2),
        admin: "false",
        partner: "false",
        client: "false",
        order: "false",
        limit_price_percentage: 3,
        email: e_email,
        password:12345678, 
        password_confirmation:12345678)
        e.emails.create(email: e_email, email_type: EmailType.all.sample)
        e.phones.create(phone: Faker::PhoneNumber.phone_number, phone_type: PhoneType.all.sample)
        e.addresses.create(street: Faker::Address.street_name, zipcode: Faker::Number.number(8), address_type: AddressType.all.sample, city: City.all.sample)
    end
    p "Criando Empregados ....[OK]"

    p "Criando Empresas "
    (1..5).to_a.each do
      c = Company.create(
        name: Faker::Company.name,
        fantasy_name: Faker::Company.suffix,
        federal_registration: Faker::Number.number(8),
        state_registration: Faker::Number.number(9),
        birth_date: Faker::Date.birthday(18, 65),
        tax_regime: ["simple", "normal", "presumed"].sample,
        description: Faker::Lorem.paragraph(2))
        c.emails.create(email: Faker::Internet.email, email_type: EmailType.all.sample)
        c.phones.create(phone: Faker::PhoneNumber.phone_number, phone_type: PhoneType.all.sample)
        c.addresses.create(street: Faker::Address.street_name, zipcode: Faker::Number.number(8), address_type: AddressType.all.sample, city: City.all.sample)
      end
    p "Criando Empresas ....[OK]"

    p "Criando Fornecedores "
      p_email= Faker::Internet.email
      fr = Faker::Number.number(8)
      p = Supplier.create!(
        name: Faker::Company.name,
        fantasy_name: Faker::Company.suffix,
        federal_registration: fr,
        state_registration: Faker::Number.number(9),
        kind: [0,1].sample,
        birth_date: Faker::Date.birthday(18, 65),
        tax_regime: ["simple", "normal", "presumed"].sample,
        description: Faker::Lorem.paragraph(2),
        user: User.create(email: fr+'@obrafacil.com', password:12345678, password_confirmation:12345678, federal_registration:fr))
        p.emails.create(email: p_email, email_type: EmailType.all.sample)
        p.phones.create(phone: Faker::PhoneNumber.phone_number, phone_type: PhoneType.all.sample)
        p.addresses.create(street: Faker::Address.street_name, zipcode: Faker::Number.number(8), address_type: AddressType.all.sample, city: City.all.sample)
    p "Criando Fornecedores ....[OK]"

    p "Criando Produtos"
    (1..200).to_a.each do
      Product.create!(
        name: Faker::Commerce.product_name,
        description: Faker::Commerce.product_name,
        ncm: Faker::Code.isbn,
        ipi: Faker::Number.decimal(2),
        cest: Faker::Number.decimal(2),
        icms: Faker::Number.decimal(2),
        bar_code: Faker::Code.ean,
        reduction: Faker::Number.decimal(2),
        weight: Faker::Number.decimal(2),
        height: Faker::Number.decimal(2),
        width: Faker::Number.decimal(2),
        length: Faker::Number.decimal(2),
        supplier: Supplier.all.sample,
        sku: Faker::Number.decimal(6),
        sku_xml: Faker::Number.decimal(6),
        kind: ["own", "third_party", "not_marketed"].sample,
        sub_category: SubCategory.find_or_create_by!(name: Faker::Lorem.word, category: Category.find_or_create_by!(name:Faker::Lorem.word)),
        unit: Unit.all.sample)
    end
    p "Criando Produtos ....[OK]"

    p "Criando Cashiers"
      Cashier.create!(
      start_date: Time.now-5.hour,
      finish_date: Time.now)
      Cashier.create!(
      start_date: Time.now-12.hour,
      finish_date: Time.now-6.hour)
    p "Criando Cashiers ....[OK]"

    p "Criando Payment Methods"
    PaymentMethod.create!(name: "CARTÃO DE CREDITO")
    PaymentMethod.create!(name: "CARTÃO DE DEBITO")
    PaymentMethod.create!(name: "DINHEIRO")
    PaymentMethod.create!(name: "CHEQUE")
    PaymentMethod.create!(name: "VALE")
    PaymentMethod.create!(name: "BOLETO")
    p "Criando Payment Methods ....[OK]"

    p "Criando Carriers"
    (1..10).to_a.each do
      Carrier.create!(
      name: Faker::Name.name,
      federal_registration: fr,
      state_registration: Faker::Number.number(9),
      kind: [0,1].sample,
      description: Faker::Lorem.paragraph(2))
    end
    p "Criando Carriers ....[OK]"

    p "Criando Orders"
    (1..200).to_a.each do
      o = Order.create!(
        kind: ["budget", "normal"].sample,
        description: Faker::Lorem.paragraph(2),
        discont: Faker::Commerce.price,
        freight: Faker::Commerce.price,
        billing_date: Time.now,
        price_percentage: PricePercentage.all.sample,
        employee: Employee.all.sample,
        cashier: Cashier.all.sample,
        client: Client.all.sample,
        carrier: Carrier.all.sample,
        company: Company.all.sample)
        # o.order_payments.create(payment_method: PaymentMethod.all.sample, value: Faker::Commerce.price)
    end
    p "Criando Orders ....[OK]"
  end

end
