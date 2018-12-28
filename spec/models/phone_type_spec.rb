require "rails_helper"

RSpec.describe PhoneType, type: :model do
  let(:phonetype) { build(:phone_type) }

  it { is_expected.to validate_presence_of(:name) }
end
