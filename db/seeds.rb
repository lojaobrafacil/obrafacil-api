# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'net/http'
require 'net/https' # for ruby 1.8.7
require 'json'

Employee.create!(email:"admin@admin.com", federal_registration:"12345678910", name: "SysAdmin", password:"admin2020", password_confirmation:"admin2020", admin: true)

module BRPopulate
  def self.states
    http = Net::HTTP.new('raw.githubusercontent.com', 443); http.use_ssl = true
    JSON.parse http.get('/celsodantas/br_populate/master/states.json').body
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
  "outros"]

phone_type = [
  "comercial",
  "celular",
  "residencial",
  "outro"]

email_type = [
  "nfe",
  "compras",
  "comercial",
  "pessoal",
  "outro"]

billing_type = [
  "Carteira 102",
  "Quinzenal/Mensal SNF",
  "Quinzena/Mensal CNF",
  "Somente à Vista CNF"
]

banks = [{"code":745,"name":"Banco Citibank","slug":"Citibank","description":"www.citibank.com.br"},
{"code":422,"name":"Banco Safra","slug":"Safra","description":"www.safra.com.br"},
{"code":33,"name":"Banco Santander","slug":"Santander","description":"www.santander.com.br"},
{"code":237,"name":"Bradesco","slug":"Bradesco","description":"www.bradesco.com.br"},
{"code":341,"name":"Itaú Unibanco","slug":"Itaú","description":"www.itau.com.br"},
{"code":1,"name":"BANCO DO BRASIL S/A","slug":"BRASIL"},
{"code":104,"name":"CAIXA ECONOMICA FEDERAL","slug":"CEF"},
{"code":212,"name":"BANCO ORIGINAL S/A","slug":"ORIGINAL"},
{"code":399,"name":"HSBC BANK BRASIL S/A","slug":"HSBC"},
{"code":77,"name":"BANCO IRTERMEDIUM S/A","slug":"INTERMEDIUM"},
{"code":748,"name":"BANCO COOPERATIVO SICRED ","slug":"SICRED"},
{"code":21,"name":"BANESTE S/A  BANCO DO EST. ESPIRITO SANTO ","slug":"BANESTE"},
{"code":41,"name":"BANCO DO ESTADO DO RIO GRANDE DO SUL","slug":"BANRISUL"} ]

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
[name: "X", description: "Nao definida"]]

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
type_units.each do |unit|
  Unit.create!(name: unit.first[:name], description: unit.first[:description])
end
p "Criando type_units ....[OK]"

p "BRPopulate "
BRPopulate.populate if City.all.size < 1
p "BRPopulate ....[OK]"