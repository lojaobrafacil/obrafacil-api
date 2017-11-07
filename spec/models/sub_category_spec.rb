require 'rails_helper'

RSpec.describe SubCategory, type: :model do
  let(:sub_category) { build(:sub_category) }

  it { is_expected.to validate_presence_of(:name) }
  it { should belong_to(:category) }
end
