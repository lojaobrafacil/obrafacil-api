require 'rails_helper'

RSpec.describe Unit, type: :model do
  let(:unit) { build(:unit) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:description) }

  it 'method full name' do
    unit = create(:unit)
    expect(unit.name).to eq(unit.name << '(' << unit.description << ')')
  end
end
