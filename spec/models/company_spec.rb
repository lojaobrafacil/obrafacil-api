require "rails_helper"

RSpec.describe Company, type: :model do
  let!(:company) { create(:company) }

  it { is_expected.to validate_presence_of(:name) }
  it { should define_enum_for(:tax_regime) }
end
