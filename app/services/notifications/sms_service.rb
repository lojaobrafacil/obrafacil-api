module Notifications
  class SmsService < BaseService
    attr_accessor :phone, :message

    def initialize(phone, message)
      @phone = phone
      @message = message
      super()
    end

    def can_execute?
      phone_is_valid? ? true : add_error("Phone is invalid.", 404)
    end

    def execute_action
      send_notification
    end

    def send_notification
      client = Nexmo::Client.new(api_key: ENV["NEXMO_KEY"], api_secret: ENV["NEXMO_SECRET"])
      # sms = Aws::SNS::Client.new(region: ENV["AWS_REGION"])
      begin
        client.sms.send(from: "ObraFacil", to: @phone.remove("+"), text: @message, type: "unicode")
        # sms.set_sms_attributes(attributes: { "DefaultSenderID" => "Obrafacil", "DefaultSMSType" => "Transactional" })
        # sms.publish({ message: @message, phone_number: @phone })
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
