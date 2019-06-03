module Deca
  class TypesService < Deca::BaseService
    def initialize(options = {})
      @id = options[:id] rescue nil
      @query = options[:query].collect { |k, v| "#{k}=#{CGI::escape(v.to_s)}" }.join("&") rescue nil
      @path = @id ? "tipos/#{@id}" : "tipos"
      @path = @path + "?#{@query}" if @query
      @body = options[:body] rescue nil
      super
    end
  end
end
