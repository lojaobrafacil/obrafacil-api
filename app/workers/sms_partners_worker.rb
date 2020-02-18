class SmsPartnersWorker
  include Sidekiq::Worker

  def perform(obj)
    @log = Log::Worker.create(name: "SmsPartnersWorker")
    @log_messages = { data: obj, success: [], errors: [] }
    @partners = ::Partner.where(id: obj["partner_ids"])
    @partners.map { |partner|
      @name = partner.primary_phone.contact.split(" ")[0] rescue ""
      @phone = partner.primary_phone.phone rescue nil
      @message = case obj["status"]
                 when "pre_active"
                   "[ObraFacil]Olá!Estamos aguardando seu cadastro!Cadastre se e receba vantagens e descontos a seus clientes! bit.ly/2D8RyJ7"
                 when "active"
                   "[ObraFacil]Olá #{@name}!Troque seus pontos acumulados em dinheiro ou em produtos da nossa loja até o fim deste mês! bit.ly/2D8RyJ7"
                 when "transfer_points"
                   "[ObraFácil]Olá #{@name}!Seus pontos em dinheiro foram transferidos automaticamente. Por favor conferir o valor na sua conta ou entre em contato."
                 when "points_expiration"
                   "[ObraFacil]Atenção!Amanhã vence seu prazo para resgatar seus pontos em dinheiro no Obra Fácil Mais!https://bit.ly/2D8RyJ7"
                 end
      if @phone
        service = Notifications::SmsService.new(@phone, @message)
        if service.call
          @log_messages[:success] << { partner_id: partner.id, phone_number: @phone, message: service.message }
        else
          @log_messages[:errors] << { partner_id: partner.id, phone_number: @phone, message: service.error_message }
        end
      end
    }
    @log.update(finished_at: Time.now, content: @log_messages, status: "OK")
  end
end
