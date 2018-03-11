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

User.create(email:"admhubco@obrafacil.com", federal_registration: 12345678910, kind: 0, password:"obrafaciladm", password_confirmation:"obrafaciladm")

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

banks = [[code: "75" , name: "Banco ABN Amro S.A.", slug: "ABN" ,description: "www.abnamro.com.br"],
[code: "25" , name: "Banco Alfa", slug: "Alfa" ,description: "www.alfanet.com.br"],
[code: "719", name: "Banco Banif", slug: "Banif" ,description: "www.bancobanif.com.br"],
[code: "107", name: "Banco BBM", slug: "BBM" ,description: "www.bancobbm.com.br"],
[code: "318", name: "Banco BMG", slug: "BMG" ,description: "www.bancobmg.com.br"],
[code: "218", name: "Banco Bonsucesso", slug: "Bonsucesso" ,description: "www.bancobonsucesso.com.br"],
[code: "208", name: "Banco BTG Pactual", slug: "BTG" ,description: "www.btgpactual.com.br"],
[code: "263", name: "Banco Cacique", slug: "Cacique" ,description: "www.bancocacique.com.br"],
[code: "473", name: "Banco Caixa Geral - Brasil", slug: "BCG-Brasil" ,description: "www.bcgbrasil.com.br"],
[code: "745", name: "Banco Citibank", slug: "Citibank" ,description: "www.citibank.com.br"],
[code: "721", name: "Banco Credibel", slug: "Credibel" ,description: "www.credibel.com.br"],
[code: "505", name: "Banco Credit Suisse", slug: "" ,description: "www.credit-suisse.com.br"],
[code: "707", name: "Banco Daycoval", slug: "Daycoval" ,description: "www.bancodaycoval.com.br"],
[code: "265", name: "Banco Fator", slug: "Fator" ,description: "www.bancofator.com.br"],
[code: "224", name: "Banco Fibra", slug: "Fibra" ,description: "www.bancofibra.com.br"],
[code: "121", name: "Banco Gerador", slug: "Gerador" ,description: "www.bancogerador.com.br"],
[code: "612", name: "Banco Guanabara", slug: "Guanabara" ,description: "www.bancoguanabara.com.br"],
[code: "604", name: "Banco Industrial do Brasil", slug: "BI" ,description: "www.bancoindustrial.com.br"],
[code: "320", name: "Banco Industrial e Comercial", slug: "BICBANCO" ,description: "www.bicbanco.com.br"],
[code: "653", name: "Banco Indusval", slug: "BI&P" ,description: "www.bip.b.br"],
[code: "77" , name: "Banco Intermedium", slug: "Intermedium" ,description: "www.intermedium.com.br"],
[code: "184", name: "Banco Itaú BBA", slug: "Itaú BBA" ,description: "www.itaubba.com.br"],
[code: "479", name: "Banco ItaúBank", slug: "ItaúBank" ,description: "www.itaubank.com.br"],
[code: "M09", name: "Banco Itaucred Financiamentos", slug: "Itaucred Financiamentos" ,description: "www.itaucred.com.br"],
[code: "389", name: "Banco Mercantil do Brasil", slug: "BMB" ,description: "www.mercantildobrasil.com.br"],
[code: "746", name: "Banco Modal", slug: "Modal" ,description: "www.modal.com.br"],
[code: "738", name: "Banco Morada", slug: "Morada" ,description: "www.bancomorada.com.br"],
[code: "623", name: "Banco Pan", slug: "Pan" ,description: "www.bancopan.com.br"],
[code: "611", name: "Banco Paulista", slug: "Paulista" ,description: "www.bancopaulista.com.br"],
[code: "643", name: "Banco Pine", slug: "Pine" ,description: "www.pine.com.br"],
[code: "654", name: "Banco Renner", slug: "Renner" ,description: "www.bancorenner.com.br"],
[code: "741", name: "Banco Ribeirão Preto", slug: "BRP" ,description: "www.brp.com.br"],
[code: "422", name: "Banco Safra", slug: "Safra" ,description: "www.safra.com.br"],
[code: "33" , name: "Banco Santander", slug: "Santander" ,description: "www.santander.com.br"],
[code: "637", name: "Banco Sofisa", slug: "Sofisa" ,description: "www.sofisa.com.br"],
[code: "82" , name: "Banco Topázio", slug: "Topázio" ,description: "www.bancotopazio.com.br"],
[code: "655", name: "Banco Votorantim", slug: "BV" ,description: "www.bancovotorantim.com.br"],
[code: "237", name: "Bradesco", slug: "Bradesco" ,description: "www.bradesco.com.br"],
[code: "341", name: "Itaú Unibanco", slug: "Itaú" ,description: "www.itau.com.br"]]

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
  Bank.create!(code: bank.first[:code].to_i, name: bank.first[:name], slug: bank.first[:slug], description: bank.first[:description])
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
