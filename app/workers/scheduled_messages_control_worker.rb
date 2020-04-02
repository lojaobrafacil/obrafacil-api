class ScheduledMessagesControlWorker
  include Sidekiq::Worker

  def perform
    @log = Log::Worker.create(name: "ScheduledMessagesControlWorker")
    @sms = ScheduledMessage.where(status: "active").where("next_execution = ? and (finished_at >= ? or finished_at is null) and starts_at <= ?", Date.today, Date.today, Date.today)
    @sms.map { |item| SendSmsWorker.perform_async(item.id) }
    @log.update(finished_at: Time.now, content: @log_messages, status: "OK")
  end
end
