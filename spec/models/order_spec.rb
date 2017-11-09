require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:order) { build(:order) }

  it { should define_enum_for(:kind) }
  it { is_expected.to validate_presence_of(:kind) }
  it { should belong_to(:price_percentage) }
  it { should belong_to(:employee) }
  it { should belong_to(:cashier) }
  it { should belong_to(:client) }
  it { should belong_to(:carrier) }
  it { should belong_to(:company) }

end
