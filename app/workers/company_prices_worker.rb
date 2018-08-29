class CompanyPricesWorker
  include Sidekiq::Worker

  def perform(id)
    CompanyJobs.new.generate_price_percentages(id)
  end
end
