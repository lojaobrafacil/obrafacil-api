require 'rails_helper'

RSpec.describe Cashier, type: :model do
  let!(:cashiers_actives) { create_list(:cashier, 5, active: true) }
  let!(:cashiers_inactives) { create_list(:cashier, 5, active: false) }

  it { is_expected.to validate_presence_of(:start_date) }
  it { is_expected.to validate_presence_of(:finish_date) }
  it { is_expected.to validate_uniqueness_of(:start_date) }
  it { is_expected.to validate_uniqueness_of(:finish_date) }
  it { should belong_to(:employee).required(false) }

  it 'method active' do
    expect(Cashier.active).to include cashiers_actives.first
    expect(Cashier.active).not_to include cashiers_inactives.first
  end
  it 'method inactive' do
    expect(Cashier.inactive).to include cashiers_inactives.first
    expect(Cashier.inactive).not_to include cashiers_actives.first
  end
end
