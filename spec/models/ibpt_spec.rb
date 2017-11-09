require 'rails_helper'

RSpec.describe Ibpt, type: :model do
  let(:ibnt) { build(:ibnt) }

  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_presence_of(:national_aliquota) }
  it { is_expected.to validate_presence_of(:international_aliquota) }
end
