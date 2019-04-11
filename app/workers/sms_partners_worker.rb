class SmsPartnersWorker
  include Sidekiq::Worker

  def perform(obj)
    @partners = ::Partner.where(id: obj["partner_ids"])
    @partners.map { |partner| Notifications::SmsService.new(partner.phone, @obj["message"]).call }
  end
end
