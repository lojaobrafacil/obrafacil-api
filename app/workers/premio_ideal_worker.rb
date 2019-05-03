class PremioIdealWorker
  include Sidekiq::Worker

  def perform(id, type = "PARTNER")
    case type
    when "PARTNER"
      p "ENTREI premio_ideal"
      PremioIdeal::Partner.new(id).send
    when "LOG_RETRY"
      p "ENTREI retry_by_log"
      PremioIdeal::Partner.new(id).retry_by_log
    end
  end
end
