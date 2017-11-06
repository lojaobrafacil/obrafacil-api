require 'rails_helper'

RSpec.describe Provider, type: :model do
  let!(:provider) { create(:provider) }

  it { is_expected.to validate_presence_of(:name) }
  it { should belong_to(:user) }
  it { should belong_to(:billing_type) }
  it { should define_enum_for(:kind) }
  it { should define_enum_for(:tax_regime) }
end
