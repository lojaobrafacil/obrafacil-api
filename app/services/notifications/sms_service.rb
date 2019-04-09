module Notifications
  class SmsService < BaseService
    attr_accessor :phone, :message

    def initialize(phone, message)
      @phone = phone
      @message = message
      super()
    end

    def can_execute?
      unless phone_is_valid?
        return add_error "Phone is invalid.", 404
      end
    end

    def execute_action
      send_notification
    end

    def send_notification
      sms = Aws::SNS::Client.new(region: ENV["AWS_REGION"])
      begin
        sms.set_sms_attributes(attributes: { "DefaultSenderID" => "Obrafacil", "DefaultSMSType" => "Transactional" })
        sms.publish({ message: @message, phone_number: @phone })
      rescue Exception => e
        return add_error({ error: "Falha ao tentar enviar código.", description: e.message }, 404)
      end

      return { success: true, message: "Enviado com sucesso.", status: 200 }
    end

    def phone_is_valid?
      /\A\+\d{1,2}?\d{2}\d{4,5}\d{4}\z/.match(@phone) ? true : false
    end
  end
end
