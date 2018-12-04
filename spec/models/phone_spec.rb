require 'rails_helper'

RSpec.describe Phone, type: :model do
  let(:phone) { build(:phone) }

  it { is_expected.to validate_presence_of(:phone) }

  it 'method format_phone' do
    phone = Phone.new(phone: "(11) 92345-6789")
    phone.format_phone
    expect(phone.phone).to eq("+5511923456789")
  end
end
