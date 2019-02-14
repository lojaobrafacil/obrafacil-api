class ReportUploadWorker
  include Sidekiq::Worker

  def perform(obj)
    case obj["type"]
    when "MODEL"
      model = obj["model"].classify.constantize.all
      path = ToXlsx.new(model, {titles: obj["titles"], attributes: obj["fields"], filename: obj["pathname"]}).generate
      rep = Report.find_or_initialize_by(name: "PARTNER")
      rep.attachment = File.new(path)
      rep.save
      File.delete(path) if File.exist?(path)
      Pusher.trigger("reports", "partner", {message: "Seu Relatorio esta pronto", file: rep.attachment}) rescue nil
    end
  end
end
