class PremioIdealWorker
  include Sidekiq::Worker

  def perform(partner_id)
    SendPartner.new.premio_ideal(partner_id)
  end
end
