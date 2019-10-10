require "faker"

namespace :dev do
  desc "Generate DB Faker"
  task generate_db: :environment do
    puts "== 1 \n#{%x(rake dev:generate_clients)}"
    puts "== 2 \n#{%x(rake dev:generate_partners)}"
    puts "== 3 \n#{%x(rake dev:generate_employees)}"
    puts "== 4 \n#{%x(rake dev:generate_companies)}"
    puts "== 5 \n#{%x(rake dev:generate_suppliers)}"
    puts "== 6 \n#{%x(rake dev:generate_products)}"
    puts "== 7 \n#{%x(rake dev:generate_cashiers)}"
    puts "== 8 \n#{%x(rake dev:generate_payment_methods)}"
    puts "== 9 \n#{%x(rake dev:generate_carriers)}"
    puts "== 10 \n#{%x(rake dev:generate_orders)}"
    puts "== 10 \n#{%x(rake dev:generate_highlights)}"
  end

  desc "Generate Clients faker"
  task generate_clients: :environment do
    p "Criando Clientes "
    (1..20).to_a.each do
      c_email = Faker::Internet.email
      c = Client.create!(
        name: Faker::Name.name,
        federal_registration: Faker::Number.number(digits: 8),
        state_registration: Faker::Number.number(9),
        kind: [0, 1].sample,
        status: Client.statuses.keys.sample,
        birthday: Faker::Date.birthday(min_age: 18, max_age: 65),
        renewal_date: Time.new() + (1..10).to_a.sample.year,
        tax_regime: Client.tax_regimes.keys.sample,
        description: Faker::Lorem.paragraph(2),
        order_description: Faker::Lorem.sentence(3),
        limit: Faker::Number.decimal(l_digits: 4),
      )
      c.emails.create(email: c_email, email_type: EmailType.all.sample)
      c.phones.create(phone: Faker::PhoneNumber.phone_number, phone_type: PhoneType.all.sample)
      c.addresses.create(street: Faker::Address.street_name, zipcode: Faker::Number.number(digits: 8), address_type: AddressType.all.sample, city: City.all.sample)
    end
    p "Criando Clientes ....[OK]"
  end

  desc "Generate Partners faker"
  task generate_partners: :environment do
    p "Criando Parceiros "
    (1..20).to_a.each do
      p = Partner.new(
        name: Faker::Name.name,
        federal_registration: Faker::Number.number(10),
        state_registration: Faker::Number.number(9),
        kind: [0, 1].sample,
        birthday: Faker::Date.birthday(min_age: 18, max_age: 65),
        renewal_date: Time.new() + (1..10).to_a.sample.year,
        origin: Partner.origins.keys.sample,
        status: Partner.statuses.keys.sample,
        description: Faker::Lorem.paragraph(2),
        ocupation: Faker::Lorem.sentence(3),
        bank: Bank.all.sample,
        agency: Faker::Number.number(digits: 4),
        account: Faker::Number.number(digits: 6),
        favored: Faker::Name.name,
        favored_federal_registration: Faker::Number.number(10),
        emails_attributes: [{ email: Faker::Internet.email, email_type: EmailType.all.sample }],
        phones_attributes: [{ phone: Faker::PhoneNumber.phone_number, phone_type: PhoneType.all.sample }],
        addresses_attributes: [{ street: Faker::Address.street_name, zipcode: Faker::Number.number(digits: 8), address_type: AddressType.all.sample, city: City.all.sample }],
      )
    end
    p "Criando Parceiros ....[OK]"
  end

  desc "Generate Employees faker"
  task generate_employees: :environment do
    p "Criando Empregados "
    Employee.create!(email: "partner@partner.com", federal_registration: "11111111111", name: "partner", password: "partner2020", password_confirmation: "partner2020", change_partners: true)
    Employee.create!(email: "client@client.com", federal_registration: "22222222222", name: "client", password: "client2020", password_confirmation: "client2020", change_clients: true)
    Employee.create!(email: "product@product.com", federal_registration: "33333333333", name: "product", password: "product2020", password_confirmation: "product2020", change_products: true)
    (1..20).to_a.each do
      fr = Faker::Number.unique.number(8)
      e = Employee.create!(
        name: Faker::Name.name,
        federal_registration: fr,
        state_registration: Faker::Number.number(9),
        birth_date: Faker::Date.birthday(min_age: 18, max_age: 65),
        renewal_date: Time.new() + (1..10).to_a.sample.year,
        description: Faker::Lorem.paragraph(2),
        commission_percent: Faker::Number.decimal(l_digits: 2),
        admin: "false",
        change_partners: "false",
        change_clients: "false",
        order_creation: "false",
        limit_margin: 3,
        email: fr.to_s + "@obrafacil.com",
        phone: Faker::PhoneNumber.phone_number,
        street: Faker::Address.street_name,
        zipcode: Faker::Number.number(digits: 8),
        city: City.all.sample,
        password: 12345678,
        password_confirmation: 12345678,
      )
    end
    p "Criando Empregados ....[OK]"
  end

  desc "Generate Companies faker"
  task generate_companies: :environment do
    p "Criando Empresas "
    (1..5).to_a.each do
      c = Company.create(
        name: Faker::Company.name,
        fantasy_name: Faker::Company.suffix,
        federal_registration: Faker::Number.number(digits: 8),
        state_registration: Faker::Number.number(9),
        birth_date: Faker::Date.birthday(min_age: 18, max_age: 65),
        tax_regime: Company.tax_regimes.keys.sample,
        description: Faker::Lorem.paragraph(2),
      )
      c.emails.create(email: Faker::Internet.email, email_type: EmailType.all.sample)
      c.phones.create(phone: Faker::PhoneNumber.phone_number, phone_type: PhoneType.all.sample)
      c.addresses.create(street: Faker::Address.street_name, zipcode: Faker::Number.number(digits: 8), address_type: AddressType.all.sample, city: City.all.sample)
    end
    p "Criando Empresas ....[OK]"
  end

  desc "Generate Suppliers faker"
  task generate_suppliers: :environment do
    p "Criando Fornecedores "
    p_email = Faker::Internet.email
    p = Supplier.create!(
      name: Faker::Company.name,
      fantasy_name: Faker::Company.suffix,
      federal_registration: Faker::Number.number(digits: 8),
      state_registration: Faker::Number.number(9),
      kind: [0, 1].sample,
      birth_date: Faker::Date.birthday(min_age: 18, max_age: 65),
      tax_regime: Supplier.tax_regimes.keys.sample,
      description: Faker::Lorem.paragraph(2),
    )
    p.emails.create(email: p_email, email_type: EmailType.all.sample)
    p.phones.create(phone: Faker::PhoneNumber.phone_number, phone_type: PhoneType.all.sample)
    p.addresses.create(street: Faker::Address.street_name, zipcode: Faker::Number.number(digits: 8), address_type: AddressType.all.sample, city: City.all.sample)
    p "Criando Fornecedores ....[OK]"
  end

  desc "Generate Products faker"
  task generate_products: :environment do
    p "Criando Produtos"
    (1..200).to_a.each do
      Product.create!(
        name: Faker::Commerce.product_name,
        description: Faker::Commerce.product_name,
        ipi: Faker::Number.decimal(l_digits: 2),
        barcode: Faker::Code.ean,
        reduction: Faker::Number.decimal(l_digits: 2),
        weight: Faker::Number.decimal(l_digits: 2),
        height: Faker::Number.decimal(l_digits: 2),
        width: Faker::Number.decimal(l_digits: 2),
        length: Faker::Number.decimal(l_digits: 2),
        supplier: Supplier.all.sample,
        sku: Faker::Number.number(digits: 6),
        sku_xml: Faker::Number.number(digits: 6),
        kind: Product.kinds.keys.sample,
        sub_category: SubCategory.find_or_create_by!(name: Faker::Lorem.word, category: Category.find_or_create_by!(name: Faker::Lorem.word)),
        unit: Unit.all.sample,
      )
    end
    p "Criando Produtos ....[OK]"
  end

  desc "Generate Cashiers faker"
  task generate_cashiers: :environment do
    p "Criando Cashiers"
    Cashier.create!(
      start_date: Time.now - 5.hour,
      finish_date: Time.now,
    )
    Cashier.create!(
      start_date: Time.now - 12.hour,
      finish_date: Time.now - 6.hour,
    )
    p "Criando Cashiers ....[OK]"
  end

  desc "Generate Payment Methods faker"
  task generate_payment_methods: :environment do
    p "Criando Payment Methods"
    PaymentMethod.create!(name: "CARTÃO DE CREDITO")
    PaymentMethod.create!(name: "CARTÃO DE DEBITO")
    PaymentMethod.create!(name: "DINHEIRO")
    PaymentMethod.create!(name: "CHEQUE")
    PaymentMethod.create!(name: "VALE")
    PaymentMethod.create!(name: "BOLETO")
    p "Criando Payment Methods ....[OK]"
  end

  desc "Generate Carriers faker"
  task generate_carriers: :environment do
    p "Criando Carriers"
    (1..10).to_a.each do
      Carrier.create!(
        name: Faker::Name.name,
        federal_registration: Faker::Number.number(digits: 8),
        state_registration: Faker::Number.number(9),
        kind: [0, 1].sample,
        description: Faker::Lorem.paragraph(2),
      )
    end
    p "Criando Carriers ....[OK]"
  end

  desc "Generate Orders faker"
  task generate_orders: :environment do
    p "Criando Orders"
    (1..200).to_a.each do
      o = Order.create!(
        kind: ["budget", "normal"].sample,
        description: Faker::Lorem.paragraph(2),
        discont: Faker::Commerce.price,
        freight: Faker::Commerce.price,
        billing_date: Time.now,
        selected_margin: [1, 2, 3, 4, 5].sample,
        employee: Employee.all.sample,
        cashier: Cashier.all.sample,
        client: Client.all.sample,
        carrier: Carrier.all.sample,
        company: Company.all.sample,
      )
    end
    p "Criando Orders ....[OK]"
  end

  desc "Generate Highlights faker"
  task generate_highlights: :environment do
    p "Criando Highlights"
    (1..2).to_a.each do
      Highlight.create!(
        title_1: Faker::Lorem.sentence(3).titleize,
        content_1: Faker::Lorem.paragraph(50),
        content_2: Faker::Lorem.paragraph(50),
        content_3: Faker::Lorem.paragraph(50),
        remote_image_1_url: "https://hubcoapp-images.s3-sa-east-1.amazonaws.com/campanhas/Programa-Mais-Descontos_Ita%CC%81lia-Capa_Youtube.png",
        remote_image_2_url: "https://hubcoapp-images.s3-sa-east-1.amazonaws.com/campanhas/Programa-Mais-Descontos_Ita%CC%81lia-Capa_Perfil-Comum.png",
        remote_image_3_url: "https://hubcoapp-images.s3-sa-east-1.amazonaws.com/campanhas/Programa-Mais-Descontos_Ita%CC%81lia-Instagram_Facebook.png",
        link: "campain/2019",
        kind: "campain",
        status: 1,
      )
    end
    (1..20).to_a.each do
      Highlight.create!(
        title_1: Faker::Lorem.sentence(3).titleize,
        content_1: Faker::Lorem.paragraph(1),
        remote_image_1_url: ["https://image.freepik.com/fotos-gratis/a-imagem-macro-do-close-up-das-flores-e-usada-como-uma-imagem-de-fundo-foto-macro-close-up_34433-346.jpg",
                             "https://img1.ibxk.com.br/2019/02/25/25044125149117.jpg?w=700",
                             "https://i2.wp.com/amplino.org/wp-content/uploads/2018/07/f90ad163e157e67abcf755cb526ea064.jpg?resize=541%2C494&ssl=1"].sample,
        kind: ["event", "normal", "winner"].sample,
        status: 1,
      )
    end
    p "Criando Highlights ....[OK]"
  end
end
