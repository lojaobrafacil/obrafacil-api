module Deca
  class SalesService < Deca::BaseService
    def initialize(options = {})
      @id = options[:id] rescue nil
      @query = options[:query].collect { |k, v| "#{k}=#{CGI::escape(v.to_s)}" }.join("&") rescue nil
      @path = @id ? "vendas/#{@id}" : "vendas"
      @path = @path + "?#{@query}" if @query
      super
    end

    def send(commission_id)
      @commission = Commission.find_by(id: commission_id)
      @body = body_params
      post
    end

    def body_params
      {
        data: {
          type: "vendas",
          attributes: {
            usuario_especificador_id: 12587,
            usuario_vendedor_id: 11021,
            email: "",
            nome: "teste",
            sobrenome: "teste",
            telefone: null,
            valor: "1300.00",
            pessoa_tipo: "PF",
            cpf_cnpj: 35607347000181,
            nota_fiscal: "12121",
            razao_social: null,
            data_venda: "2019-01-01",
          },
        },
      }
    end
  end
end
