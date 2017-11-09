require 'rails_helper'

RSpec.describe PricePercentage, type: :model do
  let(:price_percentages) { create(:price_percentage) }

  it { is_expected.to validate_presence_of(:margin) }
  it { is_expected.to validate_uniqueness_of(:kind) }
  it { is_expected.to validate_numericality_of(:kind) }

end
