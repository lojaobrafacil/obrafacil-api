class DecaEmployeesWorker
  include Sidekiq::Worker

  def perform(id)
    log = Log::Worker.create(name: "DecaEmployeesWorker")
    @employee = Employee.find(id)
    @body = {}
    (@body["cpf_cnpj"] = @employee.federal_registration) rescue nil
    (@body["nome"] = @employee.name.split(" ")[0]) rescue nil
    (@body["sobrenome"] = @employee.name.split(" ").drop(1).join(" ")) rescue nil
    (@body["email"] = @employee.email) rescue nil
    (@body["tel1"] = @employee.phone.phone) rescue nil
    (@body["tel2"] = @employee.phone.phone) rescue nil
    service = Deca::EmployeesService.new(query: { cpf_cnpj: @employee.federal_registration }, body: @body)
    service.get
    service.id ? service.put : service.post
    log.update(finished_at: Time.now, content: service.as_json, status: "OK")
  end
end
