require "uri"
require "net/http"

class SendPartner
  def premio_ideal(partner_id)
    partner = Partner.find(partner_id)
    body = ""
    if partner.federal_registration? and partner.federal_registration.size >= 10 and partner.active?
      begin
        body = body_params(partner)
        x = Net::HTTP.post_form(URI.parse(premio_ideal_url), body)
        status = x.code ? x.code.to_i : 422
        if status == 200
          Log::PremioIdeal.create(partner_id: partner_id, body: body.to_s, status: status, error: x.msg)
        else
          Log::PremioIdeal.create(partner_id: partner_id, body: body.to_s, status: status, error: ("Parceiro " + partner.name + " não foi para premio ideal, erro:"))
        end
      rescue
        Log::PremioIdeal.create(partner_id: partner_id, body: body.to_s, error: ("erro ao processar " + partner.name + " favor confirmar se o cadastro esta correto").as_json, status: 422)
      end
    else
      Log::PremioIdeal.create!(partner_id: partner_id, error: ("Parceiro " + partner.name + " não foi para premio ideal pois nao possue CPF/CNPJ ou esta inativo").as_json, status: status, body: nil)
    end
  end

  def retry_by_log(log_id)
    log = Log::PremioIdeal.find(log_id)
    partner = Partner.find(log.partner_id)
    if partner.federal_registration? and partner.federal_registration.size >= 10 and partner.active?
      begin
        body = body_params(partner)
        x = Net::HTTP.post_form(URI.parse(premio_ideal_url), body)
        status = x.code ? x.code.to_i : 422
        if status == 200
          log.update(body: body.to_s, status: 200, error: x.msg)
        else
          log.update(body: body.to_s, status: status, error: ("Parceiro " + partner.name + " não foi para premio ideal, erro:"))
        end
      rescue
        log.update(body: body.to_s, error: ("erro ao processar " + partner.name + " favor confirmar se o cadastro esta correto").as_json, status: status)
      end
    else
      log.update(error: ("Parceiro " + partner.name + " não foi para premio ideal pois nao possue CPF/CNPJ ou esta inativo").as_json, status: status, body: nil)
    end
  end

  def premio_ideal_url
    Rails.env.production? ? "https://premioideall.com.br/webapi/api/SingleSignOn/Login?login=deca&password=deca@acesso" : "https://homolog.markup.com.br/premioideall/webapi/api/SingleSignOn/Login?login=deca&password=deca@acesso"
  end

  def body_params(partner)
    {
      "name": partner.name.as_json,
      "cpfCnpj": partner.federal_registration.as_json,
      "address": if partner.addresses.empty? ; "null"; elsif  partner.addresses.first.street.nil? ||  partner.addresses.first.street == ""; "null"; else partner.addresses.first.street.as_json end,
      "number": if partner.addresses.empty? ; "000"; elsif  partner.addresses.first.number.nil? ||  partner.addresses.first.number == ""; "000"; else partner.addresses.first.number.as_json end,
      "complement": if partner.addresses.empty? ; "null"; elsif  partner.addresses.first.complement.nil? ||  partner.addresses.first.complement == ""; "null"; else partner.addresses.first.complement.as_json end,
      "cityRegion": if partner.addresses.empty? ; "null"; elsif  partner.addresses.first.neighborhood.nil? ||  partner.addresses.first.neighborhood == ""; "null"; else partner.addresses.first.neighborhood.as_json end,
      "city": if partner.addresses.empty? ; "null"; elsif  partner.addresses.first.city.nil? ||  partner.addresses.first.city == ""; "null"; else partner.addresses.first.city.name.as_json end,
      "state": if partner.addresses.empty? ; "nd"; elsif  partner.addresses.first.city.nil? ||  partner.addresses.first.city == ""; "nd"; else partner.addresses.first.city.state.acronym.as_json end,
      "zipcode": if partner.addresses.empty? ; "00000000"; elsif  partner.addresses.first.zipcode.nil? ||  partner.addresses.first.zipcode == ""; "00000000"; else partner.addresses.first.zipcode.as_json.tr("-","") end,
      "phoneDdd": partner.phones.empty? ? "00" :  partner.phones.first.phone.delete(' ').delete("-")[0..1].as_json,
      "phoneNumber": partner.phones.empty? ? "000000000" :  partner.phones.first.phone.delete(' ').delete("-").as_json[1..9],
      "cellDdd": partner.phones.empty? ? "00" :  partner.phones.first.phone.delete(' ').delete("-")[0..1].as_json,
      "cellNumber": partner.phones.empty? ? "000000000" :  partner.phones.first.phone.delete(' ').delete("-").as_json[1..9],
      "email": partner.emails.empty? ? "null@null.com" :  partner.emails.first.email.as_json,
      "birthDate": partner.started_date.as_json,
      "gender":0
    }
  end

end