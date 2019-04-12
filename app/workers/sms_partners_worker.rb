class SmsPartnersWorker
  include Sidekiq::Worker

  def perform(obj)
    @partners = ::Partner.where(id: obj["partner_ids"])
    @partners.map { |partner| Notifications::SmsService.new(partner.phone, "[ObraFacil]Ola #{partner.phone.contact}!Troque seus pontos acumulados em dinheiro ou em produtos da nossa loja até o fim deste mês! bit.ly/2D8RyJ7").call }
  end
end
