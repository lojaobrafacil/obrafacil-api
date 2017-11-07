require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:category) { build(:category) }

  it { is_expected.to validate_presence_of(:name) }
  it { should have_many(:sub_categories) }
end
