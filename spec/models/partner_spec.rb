require 'rails_helper'

RSpec.describe Partner, type: :model do
  let!(:partners_actives) { create_list(:partner, 5, active: true) }
  let!(:partners_inactives) { create_list(:partner, 5, active: false) }

  it { is_expected.to validate_presence_of(:name) }
  it { should belong_to(:user).required(false) }
  it { should define_enum_for(:kind) }

  it 'method active' do
    expect(Partner.active).to include partners_actives.first
    expect(Partner.active).not_to include partners_inactives.first
  end
  it 'method inactive' do
    expect(Partner.inactive).to include partners_inactives.first
    expect(Partner.inactive).not_to include partners_actives.first
  end
end
