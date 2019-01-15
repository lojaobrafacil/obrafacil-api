require "rails_helper"

RSpec.describe CashierPayment, type: :model do
  let(:cashier_payment) { create(:cashier_payment) }

  it { should belong_to(:cashier) }
  it { should belong_to(:payment_method) }
  it { is_expected.to validate_numericality_of(:value) }
  it { is_expected.to validate_presence_of(:value) }
end
