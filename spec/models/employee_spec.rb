require 'rails_helper'

RSpec.describe Employee, type: :model do
  let!(:employees_actives) { create_list(:employee, 5, active: true) }
  let!(:employees_inactives) { create_list(:employee, 5, active: false) }

  it { Employee.included_modules.include?(Contact) === true }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to allow_value('arthur@moura.com').for(:email) }
  it { is_expected.to validate_presence_of(:name) }
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
