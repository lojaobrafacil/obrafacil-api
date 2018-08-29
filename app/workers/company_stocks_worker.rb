class CompanyStocksWorker
  include Sidekiq::Worker

  def perform(id)
    CompanyJobs.new.generate_stocks(id)
  end
end
