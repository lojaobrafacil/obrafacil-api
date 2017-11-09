require 'rails_helper'

RSpec.describe PaymentMethod, type: :model do
  let(:payment_method) { build(:payment_method) }

  it { is_expected.to validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
end
