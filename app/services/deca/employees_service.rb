module Deca
  class EmployeesService < Deca::BaseService
    def initialize(options = {})
      @id = options[:id] rescue nil
      @query = options[:query].collect { |k, v| "#{k}=#{CGI::escape(v.to_s)}" }.join("&") rescue nil
      @path = @id ? "vendedores/#{@id}" : "vendedores"
      @path = @path + "?#{@query}" if @query
      @body = { "data": { "type": "vendedores", "attributes": options[:body] } }
      super
    end
  end
end
