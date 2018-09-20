class PremioIdealWorker
  include Sidekiq::Worker

  def perform(id, type = 'PARTNER')
    case type
    when 'PARTNER'
      SendPartner.new.premio_ideal(id)
    when 'LOG_RETRY'
      SendPartner.new.retry_by_log(id)
    end
  end
end
