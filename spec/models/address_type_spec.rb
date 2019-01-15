require "rails_helper"

RSpec.describe AddressType, type: :model do
  let(:addresstype) { build(:address_type) }

  it { is_expected.to validate_presence_of(:name) }
end
