class PremioIdealWorker
  include Sidekiq::Worker

  def perform(id, type = 'PARTNER')
    case type
    when 'PARTNER'
      SendPartner.new.premio_ideal(id)
    when 'LOG_RETRY'
      RetryPartner.new.premio_ideal(id)
    end
  end
end
