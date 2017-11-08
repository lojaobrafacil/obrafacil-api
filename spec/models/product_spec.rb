require 'rails_helper'

RSpec.describe Product, type: :model do
  let!(:products_actives) { create_list(:product, 5, active: true) }
  let!(:products_inactives) { create_list(:product, 5, active: false) }

  it { is_expected.to validate_presence_of(:name) }
  it { should define_enum_for(:kind) }
  it { should belong_to(:unit) }
  it { should belong_to(:company) }
  it { should belong_to(:sub_category) }

  it 'method active' do
    expect(Product.active).to include products_actives.first
    expect(Product.active).not_to include products_inactives.first
  end
  it 'method inactive' do
    expect(Product.inactive).to include products_inactives.first
    expect(Product.inactive).not_to include products_actives.first
  end

end
