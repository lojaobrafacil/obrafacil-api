require 'rails_helper'

RSpec.describe Address, type: :model do
  let(:address) { build(:address) }

  it { is_expected.to validate_presence_of(:street) }
  it { is_expected.to validate_presence_of(:zipcode) }
  it { should belong_to(:address_type) }
  it { should belong_to(:city) }
end
