class DecaPartnersWorker
  include Sidekiq::Worker

  def perform(id)
    log = Log::Worker.create(name: "DecaPartnersWorker")
    @partner = Partner.find(id)
    @body = {}
    (@body["cpf_cnpj"] = @partner.federal_registration) rescue nil
    (@body["nome"] = @partner.name.split(" ")[0]) rescue nil
    (@body["sobrenome"] = @partner.name.split(" ").drop(1).join(" ")) rescue nil
    (@body["email"] = @partner.primary_email.email) rescue nil
    (@body["data_nasc"] = @partner.started_date) rescue nil
    (@body["tipo_profissao_id"] = 6) rescue nil
    (@body["tel1"] = @partner.primary_phone.phone) rescue nil
    (@body["rg"] = @partner.state_registration) rescue nil
    if address = @partner.addresses.first
      (@body["cep"] = address.zipcode) rescue nil
      (@body["endereco"] = address.street) rescue nil
      (@body["numero"] = address.number) rescue nil
      (@body["complemento"] = address.complement) rescue nil
      (@body["bairro"] = address.neighborhood) rescue nil
      (@body["cidade"] = address.city.name) rescue nil
      (@body["estado_uf"] = address.city.state.acrym) rescue nil
    end
    service = Deca::PartnersService.new(query: { cpf_cnpj: @partner.federal_registration }, body: @body)
    service.get
    service.id ? service.put : service.post
    log.update(finished_at: Time.now, content: service.as_json, status: "OK")
  end
end
