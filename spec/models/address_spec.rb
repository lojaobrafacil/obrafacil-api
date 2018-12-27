require 'rails_helper'

RSpec.describe Address, type: :model do

  it "is valid with valid attributes" do
    byebug
    expect(Address.new(attributes_for(:address))).to be_valid
  end

  # it { is_expected.to validate_presence_of(:street) }
  # it { is_expected.to validate_presence_of(:zipcode) }
  # it { should belong_to(:address_type) }
  # it { should belong_to(:city) }
end
