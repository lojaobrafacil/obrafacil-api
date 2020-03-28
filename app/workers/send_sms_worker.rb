class SendSmsWorker
  include Sidekiq::Worker

  def perform(scheduled_message_id)
    @log = Log::Worker.create(name: "SendSmsWorker")
    @scheduled_message = ScheduledMessage.find_by(id: scheduled_message_id)
    @log_messages = { scheduled_message: @scheduled_message, success: [], errors: [] }
    if @scheduled_message
      @receivers = @scheduled_message["receiver_type"].classify.constantize.where(id: @scheduled_message[:receiver_ids])
      @receivers.map { |receiver|
        @phone = receiver.class.to_s == "Employee" ? receiver.celphone : receiver.primary_phone.phone rescue nil
        if @phone
          service = Notifications::SmsService.new(@phone, @scheduled_message.text)
          if service.call
            @log_messages[:success] << { type: @scheduled_message["receiver_type"], id: receiver.id, phone_number: @phone, message: service.message }
          else
            @log_messages[:errors] << { type: @scheduled_message["receiver_type"], id: receiver.id, phone_number: @phone, message: service.error_message }
          end
        else
          @log_messages[:errors] << { type: @scheduled_message["receiver_type"], id: receiver.id, phone_number: @phone, message: "Telefone nao encontrado" }
        end
      }
      @log.update(finished_at: Time.now, content: @log_messages, status: "OK")
    else
      @log.update(finished_at: Time.now, content: "Mensagem programada nao encontrada", status: "ERROR")
    end
    @scheduled_message.update(last_execution: Date.today)
  end
end
