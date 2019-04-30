module Deca
  class SalesService < Deca::BaseService
    def initialize(options = {})
      @id = options[:id] rescue nil
      @query = options[:query].collect { |k, v| "#{k}=#{CGI::escape(v.to_s)}" }.join("&") rescue nil
      @path = @id ? "vendas/#{@id}" : "vendas"
      @path = @path + "?#{@query}" if @query
      @body = { "data": { "type": "vendas", "attributes": options[:body] } }
      super
    end
  end
end
