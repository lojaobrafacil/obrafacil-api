module Deca
  class DesksService < Deca::BaseService
    def initialize(options = {})
      # options filter=Razão Social3&sort=razao_social&cpf_cnpj=88.857.999/0001-30
      @id = options[:id] rescue nil
      @query = options[:query].collect { |k, v| "#{k}=#{CGI::escape(v.to_s)}" }.join("&") rescue nil
      @path = @id ? "escritorios/#{@id}" : "escritorios"
      @path = @path + "?#{@query}" if @query
      @body = { "data": { "type": "escritorios", "attributes": options[:body] } }
      super
    end
  end
end
