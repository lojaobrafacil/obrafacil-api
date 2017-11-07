require 'rails_helper'

RSpec.describe Permission, type: :model do
  let(:permission) { build(:permission) }

  it { is_expected.to validate_presence_of(:name) }
  # it { should validate_uniqueness_of(:name).case_insensitive }
  it { should have_and_belong_to_many(:employees) }
end
