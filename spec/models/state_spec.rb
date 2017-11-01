require 'rails_helper'

RSpec.describe State, type: :model do
  let(:state) { build(:state) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:acronym) }
  it { should belong_to(:region) }
  it { should have_many(:cities) }
end
