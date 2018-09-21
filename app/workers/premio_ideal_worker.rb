class PremioIdealWorker
  include Sidekiq::Worker

  def perform(id, type = 'PARTNER')
    case type
    when 'PARTNER'
      p "ENTREI premio_ideal"
      SendPartner.new.premio_ideal(id)
    when 'LOG_RETRY'
      p "ENTREI retry_by_log"
      SendPartner.new.retry_by_log(id)
    end
  end
end
