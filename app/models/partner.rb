class Partner < ApplicationRecord
  belongs_to :bank, optional: true
  belongs_to :user, optional: true
  belongs_to :partner_group, optional: true
  has_many :log_premio_ideals, class_name: "Log::PremioIdeal", dependent: :destroy
  has_many :commissions, dependent: :destroy
  has_many :pi_vouchers
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
  after_save :update_user, :premio_ideal, :default_values
  before_destroy :remove_relations
  alias_attribute :vouchers, :pi_vouchers

  def self.active; where("active = true").order(:id); end
  def self.inactive; where("active = false").order(:id); end

  def email; emails.find_by(primary: true)&.email || emails.first&.email; end

  def commissions_by_year(year); commissions.where("extract(year from order_date) = ?", year); end

  def default_values
    self.name.strip
  end

  def update_user
    if self.active
      if user = self.user
        user.update(federal_registration: self.federal_registration.to_s, email: self.federal_registration.to_s + "@obrafacil.com") if user.federal_registration != self.federal_registration
      elsif user = User.find_by(federal_registration: self.federal_registration)
        user.update(partner: self)
      else
        self.build_user(email: self.federal_registration.to_s + "@obrafacil.com",
                        federal_registration: self.federal_registration,
                        password: "obrafacil2018",
                        password_confirmation: "obrafacil2018").save
      end
    else
      u = self.user
      if u
        u.update(partner: nil)
        u.destroy
      end
    end
  end

  def premio_ideal
    partner_id = self.id
    body = ""
    if self.active?
      if self.federal_registration? && self.federal_registration.size >= 10
        begin
          body = self.body_params
          x = Net::HTTP.post_form(URI.parse(premio_ideal_url), body)
          status = x.code ? x.code.to_i : 422
          response = JSON.parse(x.body)
          if status == 200 && (response["success"] == "true" || response["success"] == true)
            Log::PremioIdeal.create(partner_id: partner_id, body: body.to_s, status: status, error: x.msg)
          else
            Log::PremioIdeal.create(partner_id: partner_id, body: body.to_s, status: 422, error: ("Parceiro " + self.name + " não foi para premio ideal, erro: #{response["message"]}").as_json)
          end
        rescue
          Log::PremioIdeal.create(partner_id: partner_id, body: body.to_s, status: 422, error: ("erro ao processar " + self.name + " favor confirmar se o cadastro esta correto").as_json)
        end
      else
        Log::PremioIdeal.create!(partner_id: partner_id, body: nil, status: status, error: ("Parceiro " + self.name + " não foi para premio ideal pois nao possue CPF/CNPJ").as_json)
      end
    end
  end

  def premio_ideal_url
    "https://premioideall.com.br/webapi/api/SingleSignOn/Login?login=deca&password=deca@acesso"
  end

  def body_params
    {
      "name": self.name.as_json,
      "cpfCnpj": self.federal_registration.as_json,
      "address": if self.addresses.empty?; "null"; elsif self.addresses.first.street.nil? || self.addresses.first.street == ""; "null"; else self.addresses.first.street.as_json end,
      "number": if self.addresses.empty?; "000"; elsif self.addresses.first.number.nil? || self.addresses.first.number == ""; "000"; else self.addresses.first.number.as_json end,
      "complement": if self.addresses.empty?; "null"; elsif self.addresses.first.complement.nil? || self.addresses.first.complement == ""; "null"; else self.addresses.first.complement.as_json end,
      "cityRegion": if self.addresses.empty?; "null"; elsif self.addresses.first.neighborhood.nil? || self.addresses.first.neighborhood == ""; "null"; else self.addresses.first.neighborhood.as_json end,
      "city": if self.addresses.empty?; "null"; elsif self.addresses.first.city.nil? || self.addresses.first.city == ""; "null"; else self.addresses.first.city.name.as_json end,
      "state": if self.addresses.empty?; "nd"; elsif self.addresses.first.city.nil? || self.addresses.first.city == ""; "nd"; else self.addresses.first.city.state.acronym.as_json end,
      "zipcode": if self.addresses.empty?; "00000000"; elsif self.addresses.first.zipcode.nil? || self.addresses.first.zipcode == ""; "00000000"; else self.addresses.first.zipcode.as_json.tr("-", "") end,
      "phoneDdd": self.phones.empty? ? "00" : self.phones.first.phone.delete(" ").delete("-")[3..4].as_json,
      "phoneNumber": self.phones.empty? ? "000000000" : self.phones.first.phone.delete(" ").delete("-")[5..13].as_json,
      "cellDdd": self.phones.empty? ? "00" : self.phones.first.phone.delete(" ").delete("-")[3..4].as_json,
      "cellNumber": self.phones.empty? ? "000000000" : self.phones.first.phone.delete(" ").delete("-")[5..13].as_json,
      "email": self.emails.empty? ? "null@null.com" : self.emails.first.email.as_json,
      "birthDate": self.started_date.as_json,
      "gender": 0,
    }
  end

  def remove_relations
    self.update(active: false)
    log = self.log_premio_ideals
    if log
      log.each do |l|
        Log::PremioIdeal.find(l.id)
      end
    end
    u = self.user
    if u
      u.update(partner: nil)
      u.destroy
    end
  end

  def self.commissions_by_year(year)
    Partner.select("partners.name as nome_parceiro, 
      (select coalesce(sum(c.order_price), 0) from commissions as c where c.partner_id = partners.id and extract(year from c.order_date) = #{year} and extract(month from c.order_date) = 01) as janeiro, 
      (select coalesce(sum(c.order_price), 0) from commissions as c where c.partner_id = partners.id and extract(year from c.order_date) = #{year} and extract(month from c.order_date) = 02) as fevereiro, 
      (select coalesce(sum(c.order_price), 0) from commissions as c where c.partner_id = partners.id and extract(year from c.order_date) = #{year} and extract(month from c.order_date) = 03) as marco, 
      (select coalesce(sum(c.order_price), 0) from commissions as c where c.partner_id = partners.id and extract(year from c.order_date) = #{year} and extract(month from c.order_date) = 04) as abril, 
      (select coalesce(sum(c.order_price), 0) from commissions as c where c.partner_id = partners.id and extract(year from c.order_date) = #{year} and extract(month from c.order_date) = 05) as maio, 
      (select coalesce(sum(c.order_price), 0) from commissions as c where c.partner_id = partners.id and extract(year from c.order_date) = #{year} and extract(month from c.order_date) = 06) as junho, 
      (select coalesce(sum(c.order_price), 0) from commissions as c where c.partner_id = partners.id and extract(year from c.order_date) = #{year} and extract(month from c.order_date) = 07) as julho, 
      (select coalesce(sum(c.order_price), 0) from commissions as c where c.partner_id = partners.id and extract(year from c.order_date) = #{year} and extract(month from c.order_date) = 08) as agosto, 
      (select coalesce(sum(c.order_price), 0) from commissions as c where c.partner_id = partners.id and extract(year from c.order_date) = #{year} and extract(month from c.order_date) = 09) as setembro, 
      (select coalesce(sum(c.order_price), 0) from commissions as c where c.partner_id = partners.id and extract(year from c.order_date) = #{year} and extract(month from c.order_date) = 10) as outubro, 
      (select coalesce(sum(c.order_price), 0) from commissions as c where c.partner_id = partners.id and extract(year from c.order_date) = #{year} and extract(month from c.order_date) = 11) as novembro, 
      (select coalesce(sum(c.order_price), 0) from commissions as c where c.partner_id = partners.id and extract(year from c.order_date) = #{year} and extract(month from c.order_date) = 12) as dezembro")
  end
end
