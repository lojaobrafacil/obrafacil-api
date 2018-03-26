# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
# #
# # Examples:
# #
# #   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
# #   Character.create(name: 'Luke', movie: movies.first)
# require 'net/http'
# require 'net/https' # for ruby 1.8.7
# require 'json'

# User.create(email:"12345678910@obrafacil.com", federal_registration: 12345678910, kind: 0, password:"obrafaciladm", password_confirmation:"obrafaciladm")

# module BRPopulate
#   def self.states
#     http = Net::HTTP.new('raw.githubusercontent.com', 443); http.use_ssl = true
#     JSON.parse http.get('/celsodantas/br_populate/master/states.json').body
#   end

#   def self.capital?(city, state)
#     city["name"] == state["capital"]
#   end

#   def self.populate
#     states.each do |state|
#       region_obj = Region.find_or_create_by(:name => state["region"])
#       state_obj = State.new(:acronym => state["acronym"], :name => state["name"], :region => region_obj)
#       state_obj.save

#       state["cities"].each do |city|
#         c = City.new
#         c.name = city["name"]
#         c.state = state_obj
#         c.capital = capital?(city, state)
#         c.save
#       end
#     end
#   end
# end

# address_type = [
#   "comercial",
#   "entrega",
#   "cobrança",
#   "outros"]

# phone_type = [
#   "comercial",
#   "celular",
#   "residencial",
#   "outro"]

# email_type = [
#   "nfe",
#   "compras",
#   "comercial",
#   "pessoal",
#   "outro"]

# billing_type = [
#   "Carteira 102",
#   "Quinzenal/Mensal SNF",
#   "Quinzena/Mensal CNF",
#   "Somente à Vista CNF"
# ]

# banks = [{"code":745,"name":"Banco Citibank","slug":"Citibank","description":"www.citibank.com.br"},
# {"code":422,"name":"Banco Safra","slug":"Safra","description":"www.safra.com.br"},
# {"code":33,"name":"Banco Santander","slug":"Santander","description":"www.santander.com.br"},
# {"code":237,"name":"Bradesco","slug":"Bradesco","description":"www.bradesco.com.br"},
# {"code":341,"name":"Itaú Unibanco","slug":"Itaú","description":"www.itau.com.br"},
# {"code":1,"name":"BANCO DO BRASIL S/A","slug":"BRASIL"},
# {"code":104,"name":"CAIXA ECONOMICA FEDERAL","slug":"CEF"},
# {"code":212,"name":"BANCO ORIGINAL S/A","slug":"ORIGINAL"},
# {"code":399,"name":"HSBC BANK BRASIL S/A","slug":"HSBC"},
# {"code":77,"name":"BANCO IRTERMEDIUM S/A","slug":"INTERMEDIUM"},
# {"code":748,"name":"BANCO COOPERATIVO SICRED ","slug":"SICRED"},
# {"code":21,"name":"BANESTE S/A - BANCO DO EST. ESPIRITO SANTO ","slug":"BANESTE"},
# {"code":41,"name":"BANCO DO ESTADO DO RIO GRANDE DO SUL","slug":"BANRISUL"} ]

# type_units = [
# [name: "m2", description: "Metro quadrado"],
# [name: "cm2", description: "Centímetro quadrado"],
# [name: "m", description: "Metro"],
# [name: "cm", description: "Centímetro"],
# [name: "UN", description: "Unidade"],
# [name: "CT", description: "Cartela"],
# [name: "CX", description: "Caixa"],
# [name: "DZ", description: "Duzia"],
# [name: "GZ", description: "Groza"],
# [name: "PA", description: "Par"],
# [name: "PÇ", description: "Peça"],
# [name: "PR", description: "Par"],
# [name: "PT", description: "Pacote"],
# [name: "RL", description: "Rolo"],
# [name: "kg", description: "Kilograma"],
# [name: "g", description: "Grama"],
# [name: "SC60", description: "Saca 60Kg"],
# [name: "l", description: "Litro"],
# [name: "m3", description: "Metro cúbico"],
# [name: "ml", description: "Mililitro"],
# [name: "X", description: "Nao definida"]]

# p "Criando address_type "
# address_type.each do |type|
#   AddressType.find_or_create_by!(name: type)
# end
# p "Criando address_type ....[OK]"

# p "Criando phone_type "
# phone_type.each do |type|
#   PhoneType.find_or_create_by!(name: type)
# end
# p "Criando phone_type ....[OK]"

# p "Criando email_type "
# email_type.each do |type|
#   EmailType.find_or_create_by!(name: type)
# end
# p "Criando email_type ....[OK]"

# p "Criando billing_type "
# billing_type.each do |type|
#   BillingType.find_or_create_by!(name: type)
# end
# p "Criando billing_type ....[OK]"

# p "Criando banks "
# Bank.destroy_all if Bank.all.size > 1
# banks.each do |bank|
#   Bank.create!(code: bank[:code].to_i, name: bank[:name], slug: bank[:slug], description: bank[:description])
# end
# p "Criando banks ....[OK]"

# p "Criando type_units "
# Unit.destroy_all if Unit.all.size > 1
# type_units.each do |unit|
#   Unit.create!(name: unit.first[:name], description: unit.first[:description])
# end
# p "Criando type_units ....[OK]"

# p "BRPopulate "
# BRPopulate.populate if City.all.size < 1
# p "BRPopulate ....[OK]"



def premio_ideal(partner)
  require "uri"
  require "net/http"
  # p partner
  if partner.federal_tax_number? and partner.federal_tax_number.size >= 10
    body = {
      "name": valuePremioIdeal(partner.name.as_json),
      "cpfCnpj": partner.federal_tax_number.as_json,
      "address": partner.addresses.nil? ? valuePremioIdeal(partner.addresses.first.street.as_json) : "null",
      "number": partner.addresses.nil? ? valuePremioIdeal(partner.addresses.first.number.as_json) : "null",
      "complement": partner.addresses.nil? ? valuePremioIdeal(partner.addresses.first.complement.as_json) : "null",
      "cityRegion": partner.addresses.nil? ? valuePremioIdeal(partner.addresses.first.neighborhood.as_json) : "null",
      "city": partner.addresses.nil? ? valuePremioIdeal(partner.addresses.first.city.name.as_json) : "null",
      "state": partner.addresses.nil? ? valuePremioIdeal(partner.addresses.first.city.state.acronym.as_json) : "null",
      "zipcode": partner.addresses.nil? ? valuePremioIdeal(partner.addresses.first.zipcode.as_json.tr("-","")) : "null",
      "phoneDdd": partner.phones.nil? ? valuePremioIdeal(partner.phones.first.phone.delete(' ').delete("-")[0..1].as_json) : "null",
      "phoneNumber": partner.phones.nil? ? valuePremioIdeal(partner.phones.first.phone.delete(' ').delete("-").as_json[1..9]) : "null",
      "cellDdd": partner.phones.nil? ? valuePremioIdeal(partner.phones.first.phone.delete(' ').delete("-")[0..1].as_json) : "null",
      "cellNumber": partner.phones.nil? ? valuePremioIdeal(partner.phones.first.phone.delete(' ').delete("-").as_json[1..9]) : "null",
      "email": partner.emails.nil? ? valuePremioIdeal(partner.emails.first.email.as_json) : "null",
      "birthDate": valuePremioIdeal(partner.started_date.as_json),
      "gender":0
    }
    p Rails.env.production?
    x = Net::HTTP.post_form(URI.parse("https://homolog.markup.com.br/premioideall/webapi/api/SingleSignOn/Login?login=deca&password=deca@acesso"), body) unless Rails.env.production? # homologaçao
    x = Net::HTTP.post_form(URI.parse("https://premioideall.com.br/api/SingleSignOn/Login?login=deca&password=acesso@deca"), body) if Rails.env.production? # produçao
    x.body
    p "ok parceiro: " + partner.id.to_s
  else
    p "Parceiro " + partner.id.to_s + " não foi para premio ideal pois nao possue CPF/CNPJ"
  end
end

def valuePremioIdeal(val)
  val.nil? || val.empty? ? "null" : val
end

Partner.all.each do |par|
  premio_ideal(par)
end