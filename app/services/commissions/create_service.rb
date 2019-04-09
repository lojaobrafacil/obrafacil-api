module Commissions
  class CreateService < BaseService
    attr_accessor :success, :errors, :content

    def initialize(commissions)
      @commissions = commissions
      @success = {}
      @errors = {}
      super()
    end

    def can_execute?
      @commissions.empty? ? add_error("Commissions is empty.", 404) : true
    end

    def execute_action
      generate
    end

    def generate
      begin
        @commissions.each do |c|
          commission = Commission.new(
            partner_id: c.partner_id,
            order_id: c.order_id,
            order_date: c.order_date,
            order_price: c.order_price,
            client_name: c.client_name,
            return_price: c.return_price,
            points: c.points,
            percent: c.percent,
            percent_date: c.percent_date,
            sent_date: c.sent_date,
          )

          commission.save ? @success << c : @error << c
        end
      rescue
        return add_error({ error: "Falha ao processar, verifique o conteudo.", content: @commissions }, 404)
      end
      return { success: true, message: { success: @success, errors: @errros }, status: 200 }
    end
  end
end
