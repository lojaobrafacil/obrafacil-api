class ReportUploadWorker
  include Sidekiq::Worker

  def perform(obj)
    Report.where("DATE(created_at) <= ?", Date.today - 1.day).destroy_all
    case obj["type"]
    when "MODEL"
      model = obj["model"].classify.constantize.all
      if Report.where("name: ? and created_at BETWEEN ? AND ?", obj["model"].upcase, Time.now - 1.min, Time.now + 1.min).empty?
        path = ToXlsx.new(model, { titles: obj["titles"], attributes: obj["fields"], filename: obj["pathname"] }).generate
        rep = Report.create(name: obj["model"].upcase, employee_id: obj["user_id"], attachment: File.new(path))
        File.delete(path) if File.exist?(path)
        Pusher.trigger("reports-#{obj["user_id"]}", "partner", { message: "Seu relatório está pronto.", file: rep.attachment })
      end
    end
  end
end
