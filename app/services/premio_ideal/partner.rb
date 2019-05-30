module PremioIdeal
  class Partner
    def initialize(partner_id)
      @partner_id = partner_id
      @partner = ::Partner.find_by(id: partner_id)
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
      query_response = ActiveRecord::Base.connection.execute("select 
        partners.name, 
        COALESCE(partners.favored_federal_registration, partners.federal_registration) as cpfCnpj, 
        COALESCE(addresses.street, 'null') as address,
        COALESCE(addresses.number, '000') as number, 
        COALESCE(addresses.complement, 'null') as complement, 
        COALESCE(addresses.neighborhood, 'null') as cityRegion,
        COALESCE(cities.name, 'null') as city, 
        COALESCE(states.acronym, 'nd') as state, 
        COALESCE(addresses.zipcode, '00000000') as zipcode, 
        COALESCE(SUBSTRING(phones.phone, 4, 2), '00') as phoneDdd,
        COALESCE(SUBSTRING(phones.phone, 6, 100), '000000000') as phoneNumber,
        COALESCE(SUBSTRING(phones.phone, 4, 2), '00') as cellDdd,
        COALESCE(SUBSTRING(phones.phone, 6, 100), '000000000') as cellNumber,
        COALESCE(emails.email, 'null@null.com') as email,
        phones.primary,
        partners.started_date as birthDate,
        0 as gender
      from partners, addresses, phones, cities, states, emails
        where partners.id = addresses.addressable_id 
          and	partners.id = phones.phonable_id 
          and partners.id = emails.emailable_id
          and addresses.addressable_type = 'Partner'
          and phones.phonable_type = 'Partner'
          and emails.emailable_type = 'Partner'
          and addresses.city_id = cities.id
          and cities.state_id = states.id
          and partners.id = #{@partner.id}
          and emails.primary = phones.primary
          and partners.started_date is null").as_json
      if resp = query_response.select { |e| e["primary"] == true }.first
        resp.delete "primary"
        resp
      else
        query_response.first.delete "primary"
        query_response
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
  end
end
