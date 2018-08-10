class Api::V2::PartnersController < Api::V2::Partner::ContactsController
  def show
    partner = current_api_v1_user ?  Partner.find_by(user_id: current_api_v1_user.id) : Partner.find(params[:id])
    partner = Partner.find(params[:id]) if current_api_v1_user&.admin?
    # authorize partner
    render json: partner, status: 200
  end

  def update
    partner = Partner.find(params[:id])
    # authorize partner
    if partner.update(partner_params)
      update_contact(partner)
      update_user(partner)
      premio_ideal(partner)      
      render json: partner, status: 200
    else
      render json: { errors: partner.errors }, status: 422
    end
  end
  
  private

  def partner_params
      params.permit(:id, :name, :federal_registration, :state_registration, 
      :kind, :active, :started_date, :renewal_date, :description, :origin, :percent, :agency, 
      :ocupation, :account, :favored, :user_id, :bank_id, :discount3, :discount5, :discount8, :cash_redemption)
  end

  def update_user(partner)
    if user = User.find_by(federal_registration: partner.federal_registration)
      if partner.active?
        user.update(partner: partner) unless user.partner == partner 
      else
        user.destroy unless user.partner.active?
      end
    else
      email = partner.federal_registration? ? partner.federal_registration.to_s+"@obrafacil.com" : partner.emails.first.email rescue nil
      unless email&.nil?
        partner.build_user(email: email,
                            federal_registration: partner.federal_registration,
                            password:"obrafacil2018",
                            password_confirmation:"obrafacil2018" ).save
      end
    end
  end

  def premio_ideal(partner)
    require "uri"
    require "net/http"
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
        if x.body.include?(":true")
          p "ok parceiro: " + partner.name
        else
          p "Parceiro " + partner.name + " não foi para premio ideal, erro:"
          p x.body
        end
      rescue
        "erro ao processar " + partner.name + " favor confirmar se o cadastro esta correto"
      end
    else
      p "Parceiro " + partner.name + " não foi para premio ideal pois nao possue CPF/CNPJ ou esta inativo"
    end
  end
  
end
