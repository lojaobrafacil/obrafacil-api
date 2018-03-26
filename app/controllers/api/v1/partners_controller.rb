class Api::V1::PartnersController < Api::V1::ContactsController

  def index
    partners = Partner.all
    if partners&.empty? or partners.nil? and Partner.all.size > 0
      render json: partners, status: 401
    else
      partners = params[:name] ? partners.where("LOWER(name) LIKE LOWER(?)", "%#{params[:name]}%") : partners.all
      paginate json: partners.order(:name).as_json(only: [:id, :name,:federal_tax_number, :state_registration, :active, :description]), status: 200
    end
  end

  def show
    partner = Partner.find(params[:id])
    # authorize partner
    render json: partner, status: 200
  end

  def create
    partner = Partner.new(partner_params)
    # authorize partner
    if partner.save
      update_contact(partner)
      if user = User.find_by(federal_registration: partner.federal_tax_number)
        user.update(partner: partner) unless user.partner == partner
      else
        email = partner.federal_tax_number? ? partner.federal_tax_number.to_s+"@obrafacil.com" : partner.emails.first.email rescue nil
        unless email&.nil?
          partner.build_user(email: email,
                              federal_registration: partner.federal_tax_number,
                              password:"obrafacil2018",
                              password_confirmation:"obrafacil2018" ).save
        end
      end
      # premio_ideal(partner)
      render json: partner, status: 201
    else
      render json: { errors: partner.errors }, status: 422
    end
  end

  def update
    partner = Partner.find(params[:id])
    # authorize partner
    if partner.update(partner_params)
      update_contact(partner)
      render json: partner, status: 200
    else
      render json: { errors: partner.errors }, status: 422
    end
  end

  def destroy
    partner = Partner.find(params[:id])
    # authorize partner
    partner.destroy
    head 204
  end

  def send_premio
    resultado = []
    partners = Partner.all
    partners.each do |par|
      resultado << premio_ideal(par)
    end
    render json: { result: resultado }, status: 200
  end

  private

  def partner_params
      params.require(:partner).permit(:id, :name, :federal_tax_number, :state_registration, 
      :kind, :active, :started_date, :renewal_date, :description, :origin, :percent, :agency, 
      :ocupation, :account, :favored, :user_id, :bank_id)
  end

  def premio_ideal(partner)
    require "uri"
    require "net/http"
    if partner.federal_tax_number? and partner.federal_tax_number.size > 10
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
        "phoneDdd": partner.phones.nil? ? valuePremioIdeal(partner.phones.first.phone[0..1]) : "null",
        "phoneNumber": partner.phones.nil? ? valuePremioIdeal(partner.phones.first.phone.as_json[1..9]) : "null",
        "cellDdd": partner.phones.nil? ? valuePremioIdeal(partner.phones.first.phone[0..1]) : "null",
        "cellNumber": partner.phones.nil? ? valuePremioIdeal(partner.phones.first.phone.as_json[1..9]) : "null",
        "email": partner.emails.nil? ? valuePremioIdeal(partner.emails.first.email.as_json) : "null",
        "birthDate": partner.emails.nil? ? valuePremioIdeal(partner.started_date.as_json) : "null",
        "gender":0
      }
      x = Net::HTTP.post_form(URI.parse("https://homolog.markup.com.br/premioideall/webapi/api/SingleSignOn/Login?login=deca&password=deca@acesso"), body) unless Rails.env.production? # homologaçao
      x = Net::HTTP.post_form(URI.parse("https://premioideall.com.br/api/SingleSignOn/Login?login=deca&password=acesso@deca"), body) if Rails.env.production? # produçao
      x.body
      "ok parceiro: " + partner.id.to_s
    else
      "Parceiro " + partner.id.to_s + " não foi para premio ideal pois nao possue CPF/CNPJ"
    end
  end

  def valuePremioIdeal(val)
    val.nil? || val.empty? ? "null" : val
  end
  
end
