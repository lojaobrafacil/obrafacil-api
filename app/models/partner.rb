class Partner < ApplicationRecord
  belongs_to :bank, optional: true
  belongs_to :user, optional: true
  has_many :log_premio_ideals, class_name: 'Log::PremioIdeal', dependent: :destroy
  has_many :commissions, dependent: :destroy
  has_many :phones, dependent: :destroy, as: :phonable
  has_many :addresses, dependent: :destroy, as: :addressable
  has_many :emails, dependent: :destroy, as: :emailable
  accepts_nested_attributes_for :phones, allow_destroy: true
  accepts_nested_attributes_for :addresses, allow_destroy: true
  accepts_nested_attributes_for :emails, allow_destroy: true
  accepts_nested_attributes_for :commissions, allow_destroy: true
  enum kind: [:physical, :legal]
  enum origin: [:shop, :internet, :relationship, :nivaldo]
  enum cash_redemption: [:true, :false, :maybe]
  validates_presence_of :name, :kind
  validates_uniqueness_of :federal_registration, scope: :active 
  include Contact
  after_save :update_user, :premio_ideal
  before_destroy :remove_relations

  def self.active; where("active = true").order(:id); end
  def self.inactive; where("active = false").order(:id); end

  def update_user
    partner = self
    p "entrei"
    if partner.active
      if user = partner.user
        user.update(federal_registration: partner.federal_registration.to_s, email: partner.federal_registration.to_s+'obrafacil.com')
      elsif user = User.find_by(federal_registration: partner.federal_registration)
        user.update(partner: partner)
      else
        partner.build_user(email: partner.federal_registration.to_s+"@obrafacil.com",
          federal_registration: partner.federal_registration,
          password:"obrafacil2018",
          password_confirmation:"obrafacil2018" ).save
      end
    else
      u = self.user
      if u
        u.update(partner:nil)
        u.destroy
      end
    end
  end

  def premio_ideal
    partner_id = self.id
    partner = Partner.find(partner_id)
    body = ""
    if partner.active?
      if partner.federal_registration? && partner.federal_registration.size >= 10
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
        Log::PremioIdeal.create!(partner_id: partner_id, error: ("Parceiro " + partner.name + " não foi para premio ideal pois nao possue CPF/CNPJ").as_json, status: status, body: nil)
      end
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


  def remove_relations
    self.update(active:false)
    log = self.log_premio_ideals
    if log
      log.each do |l|
        Log::PremioIdeal.find(l.id)
      end
    end
    u = self.user
    if u
      u.update(partner:nil)
      u.destroy
    end
  end
end

