class SmsPartnersWorker
  include Sidekiq::Worker

  def perform(obj)
    @partners = ::Partner.where(id: obj["partner_ids"])
    @partners.map { |partner| Notifications::SmsService.new(partner.phone, "[ObraFacil] Solicitamos que faça o resgate dos seus pontos no programa de fidelidade até o final deste mês. Dúvidas ligar 11 3031-6891").call }
  end
end
