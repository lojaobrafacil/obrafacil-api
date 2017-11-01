require 'rails_helper'

RSpec.describe City, type: :model do
  let(:city) { build(:city) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:capital) }
  it { should belong_to(:state) }
end
