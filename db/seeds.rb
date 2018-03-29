def premio_ideal(partner)
  require "uri"
  require "net/http"
  if partner.federal_tax_number? and partner.federal_tax_number.size >= 10
    body = {
      "name": partner.name.as_json,
      "cpfCnpj": partner.federal_tax_number.as_json,
      "address": partner.addresses.nil? ? "null" :  partner.addresses.first.street.as_json,
      "number": partner.addresses.nil? ? "000" :  partner.addresses.first.number.as_json,
      "complement": partner.addresses.nil? ? "null" :  partner.addresses.first.complement.as_json,
      "cityRegion": partner.addresses.nil? ? "null" :  partner.addresses.first.neighborhood.as_json,
      "city": partner.addresses.nil? ? "null" :  partner.addresses.first.city.name.as_json,
      "state": partner.addresses.nil? ? "nd" :  partner.addresses.first.city.state.acronym.as_json,
      "zipcode": partner.addresses.nil? ? "00000000" :  partner.addresses.first.zipcode.as_json.tr("-",""),
      "phoneDdd": partner.phones.nil? ? "00" :  partner.phones.first.phone.delete(' ').delete("-")[0..1].as_json,
      "phoneNumber": partner.phones.nil? ? "000000000" :  partner.phones.first.phone.delete(' ').delete("-").as_json[1..9],
      "cellDdd": partner.phones.nil? ? "00" :  partner.phones.first.phone.delete(' ').delete("-")[0..1].as_json,
      "cellNumber": partner.phones.nil? ? "000000000" :  partner.phones.first.phone.delete(' ').delete("-").as_json[1..9],
      "email": partner.emails.nil? ? "null@null.com" :  partner.emails.first.email.as_json,
      "birthDate": partner.started_date.as_json,
      "gender":0
    }
    x = Net::HTTP.post_form(URI.parse("https://homolog.markup.com.br/premioideall/webapi/api/SingleSignOn/Login?login=deca&password=deca@acesso"), body) unless Rails.env.production? # homologaçao
    x = Net::HTTP.post_form(URI.parse("https://premioideall.com.br/webapi/api/SingleSignOn/Login?login=deca&password=acesso@deca"), body) if Rails.env.production? # produçao
    if x.body.include?(":true")
      p "ok parceiro: " + partner.id.to_s
    else
      p "Parceiro " + partner.id.to_s + " não foi para premio ideal, erro:"
      p x.body
    end
  else
    p "Parceiro " + partner.id.to_s + " não foi para premio ideal pois nao possue CPF/CNPJ"
  end
end

Partner.all.each do |partner|
  premio_ideal(partner)
end