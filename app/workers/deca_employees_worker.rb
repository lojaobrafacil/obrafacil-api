class DecaEmployeesWorker
  include Sidekiq::Worker

  def perform(id)
    @employee = Employee.find(id)
    if !@employee.admin?
      log = Log::Worker.create(name: "DecaEmployeesWorker")
      service = Deca::EmployeesService.new(id: @employee.id, query: { cpf_cnpj: @employee.federal_registration })
      service.send
      log.update(finished_at: Time.now, content: service.as_json, status: "OK")
    end
  end
end
