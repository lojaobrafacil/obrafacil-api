class DecaSalesWorker
  include Sidekiq::Worker

  def perform(id)
    log = Log::Worker.create(name: "DecaSalesWorker")
    @sale = Commission.find(id)
    @body = {}
    @partner_service = Deca::PartnersService.new(query: { cpf_cnpj: @sale.partner.federal_registration })
    @employee_service = Deca::EmployeesService.new(query: { cpf_cnpj: @sale.employee.federal_registration })
    @partner_service.get
    @employee_service.get
    (@body["usuario_especificador_id"] = @partner_service.id) rescue nil
    (@body["usuario_vendedor_id"] = @employee_service.id) rescue nil
    (@body["email"] = @sale.email) rescue nil
    (@body["nome"] = @sale.name.split(" ")[0]) rescue nil
    (@body["sobrenome"] = @sale.name.split(" ").drop(1).join(" ")) rescue nil
    (@body["telefone"] = @sale.phone.phone) rescue nil
    (@body["valor"] = "1300.00") rescue nil
    (@body["pessoa_tipo"] = "PF") rescue nil
    (@body["cpf_cnpj"] = @sale.federal_registration) rescue nil
    (@body["nota_fiscal"] = "12121") rescue nil
    (@body["razao_social"] = "") rescue nil
    (@body["data_venda"] = "2019-01-01") rescue nil
    service = Deca::SalesService.new(query: { cpf_cnpj: @sale.federal_registration }, body: @body)
    service.post
    log.update(finished_at: Time.now, content: service.as_json, status: "OK")
  end
end
