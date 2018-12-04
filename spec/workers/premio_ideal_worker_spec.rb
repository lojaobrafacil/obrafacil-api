require 'rails_helper'
RSpec.describe PremioIdealWorker, type: :worker do
  it "enqueues a Company Price worker" do
    PremioIdealWorker.perform_async(1)
    expect(PremioIdealWorker.jobs.size).to eq(1)
  end
end
