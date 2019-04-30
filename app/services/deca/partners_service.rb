module Deca
  class PartnersService < Deca::BaseService
    def initialize(options = {})
      @id = options[:id] rescue nil
      @query = options[:query].collect { |k, v| "#{k}=#{CGI::escape(v.to_s)}" }.join("&") rescue nil
      @path = @id ? "especificadores/#{@id}" : "especificadores"
      @path = @path + "?#{@query}" if @query
      @body = { "data": { "type": "especificadores", "attributes": options[:body] } }
      super
    end
  end
end
