require 'rails_helper'

RSpec.describe Region, type: :model do
  let(:region) { build(:region) }

  it { is_expected.to validate_presence_of(:name) }
  it { should have_many(:states) }
end
