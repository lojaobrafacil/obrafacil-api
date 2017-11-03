require 'rails_helper'

RSpec.describe Bank, type: :model do
  let(:bank) { build(:bank) }

  it { is_expected.to validate_presence_of(:name) }
end
