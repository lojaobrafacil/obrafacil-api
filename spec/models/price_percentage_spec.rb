require 'rails_helper'

RSpec.describe PricePercentage, type: :model do
  let(:price_percentages) { create(:price_percentage) }

  it { is_expected.to validate_presence_of(:margin) }

end
