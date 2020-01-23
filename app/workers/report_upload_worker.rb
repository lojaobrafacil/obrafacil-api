class ReportUploadWorker
  include Sidekiq::Worker

  def perform(obj)
    Report.where("DATE(created_at) <= ?", Date.today - 1.day).destroy_all
    case obj["type"]
    when "MODEL"
      model = obj["ids"] ? obj["model"].classify.constantize.where(id: obj[:ids]) : obj["model"].classify.constantize.all
      if Report.where("name = ? and created_at BETWEEN ? AND ?", obj["model"].upcase, Time.now - 1.minute, Time.now + 1.minute).count == 0
        path = ToXlsx.new(model, { titles: obj["titles"], attributes: obj["fields"], filename: obj["pathname"] }).generate
        rep = Report.create(name: obj["model"].upcase, employee_id: obj["user_id"], attachment: File.new(path))
        File.delete(path) if File.exist?(path)
        Pusher.trigger("employee-#{obj["user_id"]}", "report-partner", { message: "Seu relatório de parceiros está pronto.", url: rep.attachment_url }) rescue nil
      end
    end
  end
end
