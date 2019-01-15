require "rails_helper"

RSpec.describe Client, type: :model do
  let!(:clients_actives) { create_list(:client, 5, active: true) }
  let!(:clients_inactives) { create_list(:client, 5, active: false) }

  it { is_expected.to validate_presence_of(:name) }
  it { should belong_to(:user).required(false) }
  it { should belong_to(:billing_type).required(false) }
  it { should have_many(:phones) }
  it { should have_many(:addresses) }
  it { should have_many(:emails) }
  it { should define_enum_for(:kind) }
  it { should define_enum_for(:tax_regime) }

  it "method active" do
    expect(Client.active).to include clients_actives.first
    expect(Client.active).not_to include clients_inactives.first
  end
  it "method inactive" do
    expect(Client.inactive).to include clients_inactives.first
    expect(Client.inactive).not_to include clients_actives.first
  end
end
