require "rails_helper"

RSpec.describe Carrier, type: :model do
  let!(:carriers_actives) { create_list(:carrier, 5, active: true) }
  let!(:carriers_inactives) { create_list(:carrier, 5, active: false) }

  it { is_expected.to validate_presence_of(:name) }
  it { should define_enum_for(:kind) }
  it { should have_many(:phones) }
  it { should have_many(:addresses) }
  it { should have_many(:emails) }

  it "method active" do
    expect(Carrier.active).to include carriers_actives.first
    expect(Carrier.active).not_to include carriers_inactives.first
  end
  it "method inactive" do
    expect(Carrier.inactive).to include carriers_inactives.first
    expect(Carrier.inactive).not_to include carriers_actives.first
  end
end
