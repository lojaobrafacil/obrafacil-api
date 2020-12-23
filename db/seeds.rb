# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require "net/http"
require "net/https" # for ruby 1.8.7
require "json"

if !Rails.env.production?
  Employee.create!(email: "teste@esm.com.br", federal_registration: "12345678910", name: "SysAdmin", password: "admin2020", password_confirmation: "admin2020", admin: true)
  Api.create!(name: "test", federal_registration: "12345678912", kind: 0).update(access_id: "7997CD2C9B5DDEF2478E", access_key: "4EA029056C02874149F5CC2BCF8A5C5BAD4DFAAD37E05B374E2777E43349B9A0")
end

module BRPopulate
  def self.states
    http = Net::HTTP.new("raw.githubusercontent.com", 443); http.use_ssl = true
    JSON.parse http.get("/celsodantas/br_populate/master/states.json").body
  end

  def self.capital?(city, state)
    city["name"] == state["capital"]
  end

  def self.populate
    states.each do |state|
      region_obj = Region.find_or_create_by(:name => state["region"])
      state_obj = State.new(:acronym => state["acronym"], :name => state["name"], :region => region_obj)
      state_obj.save

      state["cities"].each do |city|
        c = City.new
        c.name = city["name"]
        c.state = state_obj
        c.capital = capital?(city, state)
        c.save
      end
    end
  end
end

address_type = [
  "comercial",
  "entrega",
  "cobrança",
  "outros",
]

phone_type = [
  "comercial",
  "celular",
  "residencial",
  "outro",
]

email_type = [
  "nfe",
  "compras",
  "comercial",
  "pessoal",
  "outro",
]

billing_type = [
  "Carteira 102",
  "Quinzenal/Mensal SNF",
  "Quinzena/Mensal CNF",
  "Somente à Vista CNF",
]

banks = [
  { code: 745, name: "Banco Citibank", slug: "Citibank", description: "www.citibank.com.br" },
  { code: 422, name: "Banco Safra", slug: "Safra", description: "www.safra.com.br" },
  { code: 33, name: "Banco Santander", slug: "Santander", description: "www.santander.com.br" },
  { code: 237, name: "Bradesco", slug: "Bradesco", description: "www.bradesco.com.br" },
  { code: 341, name: "Itaú Unibanco", slug: "Itaú", description: "www.itau.com.br" },
  { code: 1, name: "BANCO DO BRASIL S/A", slug: "BRASIL" },
  { code: 104, name: "CAIXA ECONOMICA FEDERAL", slug: "CEF" },
  { code: 212, name: "BANCO ORIGINAL S/A", slug: "ORIGINAL" },
  { code: 399, name: "HSBC BANK BRASIL S/A", slug: "HSBC" },
  { code: 77, name: "BANCO IRTERMEDIUM S/A", slug: "INTERMEDIUM" },
  { code: 748, name: "BANCO COOPERATIVO SICRED ", slug: "SICRED" },
  { code: 21, name: "BANESTE S/A  BANCO DO EST. ESPIRITO SANTO ", slug: "BANESTE" },
  { code: 41, name: "BANCO DO ESTADO DO RIO GRANDE DO SUL", slug: "BANRISUL" },
]

type_units = [
  [name: "m2", description: "Metro quadrado"],
  [name: "cm2", description: "Centímetro quadrado"],
  [name: "m", description: "Metro"],
  [name: "cm", description: "Centímetro"],
  [name: "UN", description: "Unidade"],
  [name: "CT", description: "Cartela"],
  [name: "CX", description: "Caixa"],
  [name: "DZ", description: "Duzia"],
  [name: "GZ", description: "Groza"],
  [name: "PA", description: "Par"],
  [name: "PÇ", description: "Peça"],
  [name: "PR", description: "Par"],
  [name: "PT", description: "Pacote"],
  [name: "RL", description: "Rolo"],
  [name: "kg", description: "Kilograma"],
  [name: "g", description: "Grama"],
  [name: "SC60", description: "Saca 60Kg"],
  [name: "l", description: "Litro"],
  [name: "m3", description: "Metro cúbico"],
  [name: "ml", description: "Mililitro"],
  [name: "X", description: "Nao definida"],
]

payment_term = [
  { id: 1, name: "A VISTA", date1: "0", date2: "0", date3: "0" },
  { id: 2, name: "ATO/30/60", date1: "10", date2: "30", date3: "60", date4: "0", date5: "0", date6: "0" },
  { id: 3, name: "28DDL", date1: "28", date2: "0", date3: "0" },
  { id: 4, name: "30DDL", date1: "30", date2: "0", date3: "0" },
  { id: 5, name: "05/30/60/90/120dias", date1: "5", date2: "30", date3: "60", date4: "90", date5: "120", date6: "0" },
  { id: 6, name: "07/30/60/90dias", date1: "7", date2: "30", date3: "60", date4: "90", date5: "0", date6: "0" },
  { id: 7, name: "25/35 DDL", date1: "25", date2: "35", date3: "0" },
  { id: 8, name: "25/45DDL", date1: "25", date2: "45", date3: "0" },
  { id: 9, name: "28/40DDL", date1: "28", date2: "40", date3: "0" },
  { id: 10, name: "30/40DDL", date1: "30", date2: "40", date3: "0" },
  { id: 11, name: "30/45DDL", date1: "30", date2: "45", date3: "0" },
  { id: 12, name: "18/28/38DDL", date1: "18", date2: "28", date3: "38" },
  { id: 13, name: "20/30/40DDL", date1: "20", date2: "30", date3: "40" },
  { id: 14, name: "28/35/42 DDL", date1: "28", date2: "35", date3: "42" },
  { id: 15, name: "33/38/47", date1: "33", date2: "38", date3: "47" },
  { id: 16, name: "35 DDL", date1: "35", date2: "0", date3: "0" },
  { id: 17, name: "20/35/50", date1: "20", date2: "35", date3: "50" },
  { id: 18, name: "21/28/35", date1: "21", date2: "28", date3: "35" },
  { id: 19, name: "28/35", date1: "28", date2: "35", date3: "0" },
  { id: 20, name: "C/APRESENTAÄAO", date1: "0", date2: "0", date3: "0" },
  { id: 21, name: "20/30/40/50 D.D.L", date1: "20", date2: "30", date3: "40" },
  { id: 22, name: "20/30 D.D.L", date1: "20", date2: "30", date3: "0" },
  { id: 23, name: "40/50 D.D.L", date1: "40", date2: "50", date3: "0" },
  { id: 24, name: "35/45 DDL", date1: "34", date2: "45", date3: "0" },
  { id: 25, name: "25 D.D.L", date1: "25", date2: "0", date3: "0" },
  { id: 26, name: "35/42 D.D.L.", date1: "35", date2: "42", date3: "0" },
  { id: 27, name: "45 D.D.L", date1: "45", date2: "0", date3: "0" },
  { id: 28, name: "20/40 D.D.L", date1: "20", date2: "40", date3: "0" },
  { id: 29, name: "21/28 D.D.L", date1: "21", date2: "28", date3: "0" },
  { id: 30, name: "05/20/40.D.D.I", date1: "5", date2: "20", date3: "40", date4: "0", date5: "0", date6: "0" },
  { id: 31, name: "10 D.D.L", date1: "10", date2: "0", date3: "0" },
  { id: 32, name: "30/35 d.d.l", date1: "30", date2: "35", date3: "0" },
  { id: 33, name: "30/35/42 D.D.L", date1: "30", date2: "35", date3: "42" },
  { id: 34, name: "18 D.D.L", date1: "18", date2: "0", date3: "0" },
  { id: 35, name: "30/35/40/45/50/60 D.D.L", date1: "30", date2: "35", date3: "40" },
  { id: 36, name: "15 D.D.L", date1: "15", date2: "0", date3: "0" },
  { id: 37, name: "21/35 D.D.L", date1: "21", date2: "35", date3: "0" },
  { id: 38, name: "23/33 D.D.L", date1: "23", date2: "33", date3: "0" },
  { id: 39, name: "37 53 D.D.L", date1: "37", date2: "53", date3: "0" },
  { id: 40, name: "30/40/50 D.D.L", date1: "30", date2: "40", date3: "50" },
  { id: 41, name: "30/60 D.D.L", date1: "30", date2: "60", date3: "0" },
  { id: 42, name: "30/45/60 D.D.L", date1: "30", date2: "45", date3: "60" },
  { id: 43, name: "60 D.D.L.", date1: "60", date2: "0", date3: "0" },
  { id: 44, name: "05 D.D.L.", date1: "5", date2: "0", date3: "0" },
  { id: 45, name: "28/42 D.D.L", date1: "28", date2: "42", date3: "0", date4: "0", date5: "0", date6: "0" },
  { id: 46, name: "21 D.D.L", date1: "21", date2: "0", date3: "0" },
  { id: 47, name: "28/56/84/112/140", date1: "28", date2: "56", date3: "84", date4: "112", date5: "140", date6: "0" },
  { id: 48, name: "07 D.D.L.", date1: "7", date2: "0", date3: "0" },
  { id: 49, name: "28/42 D.D.L.", date1: "28", date2: "42", date3: "0" },
  { id: 50, name: "15/30/45 D.D.L", date1: "15", date2: "30", date3: "45" },
  { id: 51, name: "A VISTA / 28 D.D.L.", date1: "0", date2: "28", date3: "0", date4: "0", date5: "0", date6: "0" },
  { id: 52, name: "28/45 D.D.L.", date1: "28", date2: "45", date3: "0" },
  { id: 53, name: "35/42/55 D.D.L.", date1: "35", date2: "42", date3: "55" },
  { id: 54, name: "35/42/49 D.D.L.", date1: "35", date2: "42", date3: "49" },
  { id: 60, name: "A COMBINAR", date1: "0", date2: "0", date3: "0" },
  { id: 62, name: "30/60/90", date1: "30", date2: "60", date3: "90" },
  { id: 63, name: "07/30 dias", date1: "7", date2: "30", date3: "0" },
  { id: 64, name: "ato/30", date1: "20", date2: "30", date3: "0" },
  { id: 66, name: "28/56 D.D.L", date1: "28", date2: "56", date3: "0" },
  { id: 67, name: "10/30/60", date1: "10", date2: "30", date3: "60" },
  { id: 68, name: "10/28date", date1: "10", date2: "28", date3: "0" },
  { id: 69, name: "05/28/56 D.D.L.", date1: "5", date2: "28", date3: "56" },
  { id: 70, name: "28/56/84", date1: "28", date2: "56", date3: "84" },
  { id: 71, name: "ato/7dias", date1: "1", date2: "7", date3: "0" },
  { id: 72, name: "ATO/28/56/84", date1: "1", date2: "28", date3: "56", date4: "84", date5: "0", date6: "0" },
  { id: 73, name: "28/56/84/112", date1: "28", date2: "56", date3: "84", date4: "112", date5: "0", date6: "0" },
  { id: 74, name: "ato/30/60/90", date1: "30", date2: "60", date3: "90", date4: "0", date5: "0", date6: "0" },
  { id: 75, name: "15/30/60/90/120/150", date1: "15", date2: "30", date3: "60", date4: "90", date5: "120", date6: "150" },
  { id: 76, name: "30/60/90/120", date1: "30", date2: "60", date3: "90", date4: "120", date5: "0", date6: "0" },
  { id: 77, name: "30/60/90/120/150", date1: "30", date2: "60", date3: "90", date4: "120", date5: "150", date6: "0" },
  { id: 78, name: "28/42/56DDL", date1: "28", date2: "42", date3: "56", date4: "0", date5: "0", date6: "0" },
  { id: 79, name: "ATO / 45 date", date1: "1", date2: "45" },
  { id: 80, name: "30/60/90/120/150/180", date1: "30", date2: "60", date3: "90", date4: "120", date5: "150", date6: "180" },
]

margins = [
  { order: 0, value: 1.0712 },
  { order: 1, value: 1.04 },
  { order: 2, value: 0.988 },
  { order: 3, value: 0.95678 },
  { order: 4, value: 0.936 },
  { order: 5, value: 0.905 },
]

p "Criando address_type "
address_type.each do |type|
  AddressType.find_or_create_by!(name: type)
end
p "Criando address_type ....[OK]"

p "Criando phone_type "
phone_type.each do |type|
  PhoneType.find_or_create_by!(name: type)
end
p "Criando phone_type ....[OK]"

p "Criando email_type "
email_type.each do |type|
  EmailType.find_or_create_by!(name: type)
end
p "Criando email_type ....[OK]"

p "Criando billing_type "
billing_type.each do |type|
  BillingType.find_or_create_by!(name: type)
end
p "Criando billing_type ....[OK]"

p "Criando banks "
Bank.destroy_all if Bank.all.size > 1
banks.each do |bank|
  Bank.create!(code: bank[:code].to_i, name: bank[:name], slug: bank[:slug], description: bank[:description])
end
p "Criando banks ....[OK]"

p "Criando type_units "
Unit.destroy_all if Unit.all.size > 1
Unit.create!(type_units)
p "Criando type_units ....[OK]"

p "Criando payment_term "
PaymentTerm.destroy_all if PaymentTerm.all.size > 1
PaymentTerm.create!(payment_term)
p "Criando payment_term ....[OK]"

p "Criando Margins "
Margin.destroy_all if Margin.all.size > 1
Margin.create!(margins)
p "Criando type_units ....[OK]"

p "BRPopulate "
BRPopulate.populate if City.all.size < 1
p "BRPopulate ....[OK]"
