require 'rails_helper'

RSpec.describe BillingType, type: :model do
  let(:billing_type) { build(:billing_type) }

  it { is_expected.to validate_presence_of(:name) }
  it { should have_many(:clients) }
  it { should have_many(:partners) }
end
