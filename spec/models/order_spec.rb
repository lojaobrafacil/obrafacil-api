require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:order) { build(:order) }

  it { should define_enum_for(:kind) }
  it { is_expected.to validate_presence_of(:kind) }
  it { should belong_to(:price_percentage).required(false) }
  it { should belong_to(:employee).required(false) }
  it { should belong_to(:cashier).required(false) }
  it { should belong_to(:client).required(false) }
  it { should belong_to(:carrier).required(false) }
  it { should belong_to(:company).required(false) }

end
