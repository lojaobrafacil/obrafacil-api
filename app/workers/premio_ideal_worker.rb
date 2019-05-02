class PremioIdealWorker
  include Sidekiq::Worker

  def perform(id, type = "PARTNER")
    case type
    when "PARTNER"
      p "ENTREI premio_ideal"
      SendPartner.new(id).send
    when "LOG_RETRY"
      p "ENTREI retry_by_log"
      SendPartner.new(id).retry_by_log
    end
  end
end
