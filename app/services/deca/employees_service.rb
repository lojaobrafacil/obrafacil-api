module Deca
  class EmployeesService < Deca::BaseService
    def initialize(options = {})
      @id = options[:id] rescue nil
      @query = options[:query].collect { |k, v| "#{k}=#{CGI::escape(v.to_s)}" }.join("&") rescue nil
      @path = "vendedores"
      @path = @path + "?#{@query}" if @query
      generate_body
      super
    end

    def send
      get
      @deca_id ? put : post
    end

    def generate_body
      @employee = Employee.find(@id)
      @body = { data: { type: "vendedores", attributes: {} } }
      (@body[:data][:attributes][:cpf_cnpj] = @employee.federal_registration) rescue nil
      (@body[:data][:attributes][:nome] = @employee.name.split(" ")[0]) rescue nil
      (@body[:data][:attributes][:sobrenome] = @employee.name.split(" ").drop(1).join(" ")) rescue nil
      (@body[:data][:attributes][:email] = @employee.email) rescue nil
      (@body[:data][:attributes][:tel1] = @employee.phone.phone) rescue nil
      (@body[:data][:attributes][:tel2] = @employee.phone.phone) rescue nil
    end
  end
end
