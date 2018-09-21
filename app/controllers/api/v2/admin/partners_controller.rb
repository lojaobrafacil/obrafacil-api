class Api::V2::Admin::PartnersController < Api::V2::Admin::ContactsController

  def index
    partners = policy_scope [:admin, ::Partner]
    if partners&.empty? or partners.nil?
      render json: partners, status: 200
    else
      partners = if params[:name] && params[:federal_registration] 
        partners.where("LOWER(name) LIKE LOWER(?) and federal_registration LIKE ?", "%#{params[:name]}%", "#{params[:federal_registration]}%")
        else
          partners.all
        end
      paginate json: partners.order(:name).as_json(only: [:id, :name,:federal_registration, :state_registration, :active, :description, :cash_redemption]), status: 200
    end
  end

  def show
    partner = ::Partner.find(params[:id])
    authorize [:admin, partner]
    render json: partner, status: 200
  end

  def create
    partner = ::Partner.new(partner_params)
    authorize [:admin, partner]
    if partner.save
      update_contact(partner)
      # PremioIdealWorker.perform_async(partner.id.to_s)
      premio_ideal(partner.id)
      render json: partner, status: 201
    else
      render json: { errors: partner.errors }, status: 422
    end
  end
  
  def reset
    c ||= 0
    params[:id] ? partner = ::Partner.find(params[:id]) : (render json: { errors: "favor informar o id do parceiro"}, status: 422)
    authorize [:admin, partner]
    p = partner.as_json
    e = partner.emails.as_json
    a = partner.addresses.as_json
    pp = partner.phones.as_json
    cc = partner.commissions.as_json
    partner.destroy ? "" : (render json: { errors: "favor informar o id do parceiro"}, status: 422)
    if p = ::Partner.create(p)
      pp.each do |phone|
        p.phones.create(phone)
      end
      a.each do |address|
        p.addresses.create(address)
      end
      e.each do |email|
        p.emails.create(email)
      end
      cc.each do |commission|
        p.commissions.create(commission)
      end
      show
    elsif c > 3
      reset
      c += 1
    else
      render json: { errors: p.errors, partner: partner }, status: 422
    end
  end

  def update
    partner = ::Partner.find(params[:id])
    authorize [:admin, partner]
    fdr_old = partner.federal_registration
    fdr_new = partner_params['federal_registration']
    if partner.update(partner_params)
      update_contact(partner)
      # PremioIdealWorker.perform_async(partner.id.to_s)
      premio_ideal(partner.id)
      render json: partner, status: 200
    else
      render json: { errors: partner.errors }, status: 422
    end
  end

  def destroy
    partner = ::Partner.find(params[:id])
    authorize [:admin, partner]
    user = partner.user
    partner.destroy
    user.destroy if !user.client
    head 204
  end

  private

  def partner_params
    params.permit(policy([:admin, ::Partner]).permitted_attributes)
  end
  
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
