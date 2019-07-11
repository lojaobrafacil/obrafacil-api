class ApiPartner::SelfSerializer < ActiveModel::Serializer
  attributes :id, :name, :federal_registration, :state_registration, :agency, :account,
             :favored, :favored_federal_registration, :bank_name, :register, :site,
             :addresses, :phones, :emails, :commissions, :money_pi, :points_pi,
             :premio_ideal_rescue

  has_one :coupon

  def bank_name
    object.bank ? object.bank.name : nil
  end

  def phones
    object.phones.order(primary: :desc).map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(ApiPartner::PhoneSerializer.new(u)).serializable_hash }
  end

  def emails
    object.emails.order(primary: :desc).map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(ApiPartner::EmailSerializer.new(u)).serializable_hash }
  end

  def addresses
    object.addresses.map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(ApiPartner::AddressSerializer.new(u)).serializable_hash }
  end

  def commissions
    object.commissions.map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(ApiPartner::CommissionSerializer.new(u)).serializable_hash }
  end

  def points_pi
    # 220
    response = JSON.parse(Net::HTTP.get(URI.parse("https://premioideall.com.br/webapi/api/Participant/GetAvailableBalance?cpf=#{object.favored_federal_registration}&campaignId=220&login=deca&password=deca@acesso"))).symbolize_keys
    response[:value]
  end

  def money_pi
    # 221
    response = JSON.parse(Net::HTTP.get(URI.parse("https://premioideall.com.br/webapi/api/Participant/GetAvailableBalance?cpf=#{object.favored_federal_registration}&campaignId=221&login=deca&password=deca@acesso"))).symbolize_keys
    response[:value]
  end

  def premio_ideal_rescue
    {
      "points": "https://premioideall.com.br/LoginIntegracao.aspx?CPF=#{Base64.strict_encode64(object.favored_federal_registration)}&Campanha=#{Base64.strict_encode64("220")}",
      "money": "https://premioideall.com.br/LoginIntegracao.aspx?CPF=#{Base64.strict_encode64(object.favored_federal_registration)}&Campanha=#{Base64.strict_encode64("221")}",
    }
  end
end
