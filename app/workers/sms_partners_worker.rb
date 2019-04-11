class SmsPartnersWorker
  include Sidekiq::Worker

  def perform(obj)
    @partners = ::Partner.where(id: obj["partner_ids"])
    @partners.map { |partner| Notifications::SmsService.new(partner.phone, "[ObraFacil]Você possui pontos em nosso programa de fidelidade, solicitamos que faça seu resgate até o final deste mês. http://programamaisdescontos.com.br/").call }
  end
end
