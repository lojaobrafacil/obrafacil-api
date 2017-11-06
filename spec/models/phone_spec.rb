require 'rails_helper'

RSpec.describe Phone, type: :model do
  let(:phone) { build(:phone) }

  it { is_expected.to validate_presence_of(:phone) }
end
