module PremioIdeal
  class Partner
    def initialize(partner_id)
      @partner_id = partner_id
      @partner = Partner.find_by(id: partner_id)
    end

    def send
      partner_id = @partner_id
      register = !@partner.favored_federal_registration&.empty? ? @partner.favored_federal_registration : @partner.federal_registration
      if @partner.active?
        if register && register.size >= 10
          begin
            body = body_params
            x = Net::HTTP.post_form(URI.parse(premio_ideal_url), body)
            status = x.code ? x.code.to_i : 422
            response = JSON.parse(x.body)
            if status == 200 && (response["success"] == "true" || response["success"] == true)
              Log::PremioIdeal.create(partner_id: partner_id, body: body.to_s, status: status, error: x.msg)
            else
              Log::PremioIdeal.create(partner_id: partner_id, body: body.to_s, status: 422, error: "Parceiro " + @partner.name + " não foi para premio ideal, erro: #{response["message"]}")
            end
          rescue StandardError => e
            p e
            Log::PremioIdeal.create(partner_id: partner_id, body: body.to_s, status: 422, error: "erro ao processar " + @partner.name + " favor confirmar se o cadastro esta correto")
          end
        else
          Log::PremioIdeal.create!(partner_id: partner_id, body: nil, status: status, error: "Parceiro " + @partner.name + " não foi para premio ideal pois nao possue CPF/CNPJ")
        end
      end
    end

    def premio_ideal_url
      Rails.env.production? ? "https://premioideall.com.br/webapi/api/SingleSignOn/Login?login=deca&password=deca@acesso" : "https://homolog.markup.com.br/premioideall/webapi/api/SingleSignOn/Login?login=deca&password=deca@acesso"
    end

    def body_params
      register = @partner.favored_federal_registration && !@partner.favored_federal_registration.empty? ? @partner.favored_federal_registration : @partner.federal_registration
      {
        "name": @partner.name.as_json,
        "cpfCnpj": register,
        "address": if @partner.addresses.empty?; "null"; elsif @partner.addresses.first.street.nil? || @partner.addresses.first.street == ""; "null"; else @partner.addresses.first.street.as_json end,
        "number": if @partner.addresses.empty?; "000"; elsif @partner.addresses.first.number.nil? || @partner.addresses.first.number == ""; "000"; else @partner.addresses.first.number.as_json end,
        "complement": if @partner.addresses.empty?; "null"; elsif @partner.addresses.first.complement.nil? || @partner.addresses.first.complement == ""; "null"; else @partner.addresses.first.complement.as_json end,
        "cityRegion": if @partner.addresses.empty?; "null"; elsif @partner.addresses.first.neighborhood.nil? || @partner.addresses.first.neighborhood == ""; "null"; else @partner.addresses.first.neighborhood.as_json end,
        "city": if @partner.addresses.empty?; "null"; elsif @partner.addresses.first.city.nil? || @partner.addresses.first.city == ""; "null"; else @partner.addresses.first.city.name.as_json end,
        "state": if @partner.addresses.empty?; "nd"; elsif @partner.addresses.first.city.nil? || @partner.addresses.first.city == ""; "nd"; else @partner.addresses.first.city.state.acronym.as_json end,
        "zipcode": if @partner.addresses.empty?; "00000000"; elsif @partner.addresses.first.zipcode.nil? || @partner.addresses.first.zipcode == ""; "00000000"; else @partner.addresses.first.zipcode.as_json.tr("-", "") end,
        "phoneDdd": @partner.phones.empty? ? "00" : @partner.phones.first.phone.delete(" ").delete("-")[3..4].as_json,
        "phoneNumber": @partner.phones.empty? ? "000000000" : @partner.phones.first.phone.delete(" ").delete("-")[5..13].as_json,
        "cellDdd": @partner.phones.empty? ? "00" : @partner.phones.first.phone.delete(" ").delete("-")[3..4].as_json,
        "cellNumber": @partner.phones.empty? ? "000000000" : @partner.phones.first.phone.delete(" ").delete("-")[5..13].as_json,
        "email": @partner.email.email ? @partner.email.email : "null@null.com",
        "birthDate": @partner.started_date.as_json,
        "gender": 0,
      }
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
  end
end
