class SmsPartnersWorker
  include Sidekiq::Worker

  def perform(obj)
    @log = Log::Worker.create(name: "SmsPartnersWorker")
    @log_messages = { success: [], errors: [] }
    @partners = ::Partner.where(id: obj["partner_ids"])
    @partners.map { |partner|
      service = Notifications::SmsService.new(partner.phone.phone, "[ObraFacil]Ola #{partner.phone.contact}!Troque seus pontos acumulados em dinheiro ou em produtos da nossa loja até o fim deste mês! bit.ly/2D8RyJ7")
      if service.call
        @log_messages[:success] << { partner_id: partner.id, phone_number: partner.phone.phone, message: service.message }
      else
        @log_messages[:errors] << { partner_id: partner.id, phone_number: partner.phone.phone, message: service.error_message }
      end
    }
    @log.update(finished_at: Time.now, content: @log_messages, status: "OK")
  end
end
