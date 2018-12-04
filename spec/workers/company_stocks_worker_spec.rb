require 'rails_helper'
RSpec.describe CompanyStocksWorker, type: :worker do
  it "enqueues a Company Stocks worker" do
    CompanyStocksWorker.perform_async(1)
    expect(CompanyStocksWorker.jobs.size).to eq(1)
  end
end
