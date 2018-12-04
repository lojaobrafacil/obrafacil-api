require 'rails_helper'
RSpec.describe CompanyPricesWorker, type: :worker do
  it "enqueues a Company Price worker" do
    CompanyPricesWorker.perform_async(1)
    expect(CompanyPricesWorker.jobs.size).to eq(1)
  end
end
