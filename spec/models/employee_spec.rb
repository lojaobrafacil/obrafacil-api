require 'rails_helper'

RSpec.describe Employee, type: :model do
  let!(:employees_actives) { create_list(:employee, 5, active: true) }
  let!(:employees_inactives) { create_list(:employee, 5, active: false) }

  it { Employee.included_modules.include?(Contact) === true }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to allow_value('arthur@moura.com').for(:email) }
  it { is_expected.to validate_presence_of(:admin) }
  it { is_expected.to validate_presence_of(:partner) }
  it { is_expected.to validate_presence_of(:client) }
  it { is_expected.to validate_presence_of(:order_creation) }
  it { is_expected.to validate_presence_of(:cashier) }
  it { is_expected.to validate_presence_of(:nfe) }
  it { is_expected.to validate_presence_of(:xml) }
  it { is_expected.to validate_presence_of(:product) }
  it { is_expected.to validate_presence_of(:order_client) }
  it { is_expected.to validate_presence_of(:order_devolution) }
  it { is_expected.to validate_presence_of(:order_cost) }
  it { is_expected.to validate_presence_of(:order_done) }
  it { is_expected.to validate_presence_of(:order_price_reduce) }
  it { is_expected.to validate_presence_of(:order_inactive) }
  it { is_expected.to validate_presence_of(:limit_price_percentage) }
  it { should validate_uniqueness_of(:federal_registration).case_insensitive }
  it { should have_many(:emails) }
  it { should have_many(:phones) }
  it { should have_many(:addresses) }
  it { should have_many(:cashiers) }
  it { should have_many(:orders) }


  it 'method active' do
    expect(Employee.active).to include employees_actives.first
    expect(Employee.active).not_to include employees_inactives.first
  end
  it 'method inactive' do
    expect(Employee.inactive).to include employees_inactives.first
    expect(Employee.inactive).not_to include employees_actives.first
  end
end
