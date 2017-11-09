require 'rails_helper'

RSpec.describe Cfop, type: :model do
  let(:cfop) { build(:cfop) }

  it { is_expected.to validate_presence_of(:code) }
end
