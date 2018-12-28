require "rails_helper"

RSpec.describe CompanyProduct, type: :model do
  let!(:company_product) { create(:company_product) }

  it { is_expected.to validate_presence_of(:stock) }
  it { is_expected.to validate_presence_of(:stock_max) }
  it { is_expected.to validate_presence_of(:stock_min) }
  it { should belong_to(:company) }
  it { should belong_to(:product) }
end
