require "uri"
require "net/http"

class SendPartner
  def premio_ideal(partner_id)
    partner = Partner.find(partner_id)
    body = ""
    if partner.federal_registration? and partner.federal_registration.size >= 10 and partner.active?
      begin
        body = {
          "name": partner.name.as_json,
          "cpfCnpj": partner.federal_registration.as_json,
          "address": if partner.addresses.nil? ; "null"; elsif  partner.addresses.first.street.nil? ||  partner.addresses.first.street == ""; "null"; else partner.addresses.first.street.as_json end,
          "number": if partner.addresses.nil? ; "000"; elsif  partner.addresses.first.number.nil? ||  partner.addresses.first.number == ""; "000"; else partner.addresses.first.number.as_json end,
          "complement": if partner.addresses.nil? ; "null"; elsif  partner.addresses.first.complement.nil? ||  partner.addresses.first.complement == ""; "null"; else partner.addresses.first.complement.as_json end,
          "cityRegion": if partner.addresses.nil? ; "null"; elsif  partner.addresses.first.neighborhood.nil? ||  partner.addresses.first.neighborhood == ""; "null"; else partner.addresses.first.neighborhood.as_json end,
          "city": if partner.addresses.nil? ; "null"; elsif  partner.addresses.first.city.nil? ||  partner.addresses.first.city == ""; "null"; else partner.addresses.first.city.name.as_json end,
          "state": if partner.addresses.nil? ; "nd"; elsif  partner.addresses.first.city.nil? ||  partner.addresses.first.city == ""; "nd"; else partner.addresses.first.city.state.acronym.as_json end,
          "zipcode": if partner.addresses.nil? ; "00000000"; elsif  partner.addresses.first.zipcode.nil? ||  partner.addresses.first.zipcode == ""; "00000000"; else partner.addresses.first.zipcode.as_json.tr("-","") end,
          "phoneDdd": partner.phones.nil? ? "00" :  partner.phones.first.phone.delete(' ').delete("-")[0..1].as_json,
          "phoneNumber": partner.phones.nil? ? "000000000" :  partner.phones.first.phone.delete(' ').delete("-").as_json[1..9],
          "cellDdd": partner.phones.nil? ? "00" :  partner.phones.first.phone.delete(' ').delete("-")[0..1].as_json,
          "cellNumber": partner.phones.nil? ? "000000000" :  partner.phones.first.phone.delete(' ').delete("-").as_json[1..9],
          "email": partner.emails.nil? ? "null@null.com" :  partner.emails.first.email.as_json,
          "birthDate": partner.started_date.as_json,
          "gender":0
        }
        x = Net::HTTP.post_form(URI.parse("https://homolog.markup.com.br/premioideall/webapi/api/SingleSignOn/Login?login=deca&password=deca@acesso"), body) unless Rails.env.production? # homologaçao
        x = Net::HTTP.post_form(URI.parse("https://premioideall.com.br/webapi/api/SingleSignOn/Login?login=deca&password=deca@acesso"), body) if Rails.env.production? # produçao
        status = x.status&.is_a?(Integer) ? x.status : 422
        if x.body.include?(":true")
          status = x.status&.is_a?(Integer) ? x.status : 200
          log.create(partner_id: partner_id, body: body, status: status, error: nil)
        else
          log.create(partner_id: partner_id, body: body, status: status, error: ("Parceiro " + partner.name + " não foi para premio ideal, erro:"))
        end
      rescue
        log.create(partner_id: partner_id, body: body, error: ("erro ao processar " + partner.name + " favor confirmar se o cadastro esta correto").as_json, status: 422)
      end
    else
      log.create!(partner_id: partner_id, error: ("Parceiro " + partner.name + " não foi para premio ideal pois nao possue CPF/CNPJ ou esta inativo").as_json, status: status, body: nil)
    end
  end

  def retry_by_log(log_id)
    log = LogPremioIdeal.find(log_id)
    partner = Partner.find(log.partner_id)
    if partner.federal_registration? and partner.federal_registration.size >= 10 and partner.active?
      begin
        body = log.body
        x = Net::HTTP.post_form(URI.parse("https://homolog.markup.com.br/premioideall/webapi/api/SingleSignOn/Login?login=deca&password=deca@acesso"), body) unless Rails.env.production? # homologaçao
        x = Net::HTTP.post_form(URI.parse("https://premioideall.com.br/webapi/api/SingleSignOn/Login?login=deca&password=deca@acesso"), body) if Rails.env.production? # produçao
        status = x.status&.is_a?(Integer) ? x.status : 422
        if x.body.include?(":true")
          status = x.status&.is_a?(Integer) ? x.status : 200
          log.update(body: log.body, status: 200, )
        else
          log.update(status: status, error: ("Parceiro " + partner.name + " não foi para premio ideal, erro:"))
        end
      rescue
        log.update(error: ("erro ao processar " + partner.name + " favor confirmar se o cadastro esta correto").as_json, status: status)
      end
    else
      log.update(error: ("Parceiro " + partner.name + " não foi para premio ideal pois nao possue CPF/CNPJ ou esta inativo").as_json, status: status, body: nil)
    end
  end
end