class CommissionsWorker
  include Sidekiq::Worker

  def perform(commissions)
    log = Log::Worker.create(name: "CommissionWorker")
    service = Commissions::CreateService.new(commissions).call

    if service.status_code == 200
      log.update(finished_at: Time.now, content: service.message, status: "OK")
    else
      log.update(finished_at: Time.now, content: service.error_message, status: "ERROR")
    end
  end
end
