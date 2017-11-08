require 'rails_helper'

RSpec.describe SubCategory, type: :model do
  let(:sub_category) { build(:sub_category) }

  it { is_expected.to validate_presence_of(:name) }
  it { should belong_to(:category) }

  it 'method disassociate_products!' do
    subcategory = create(:sub_category)
    subcategory.products.create(attributes_for(:product))
    prods = subcategory.products
    subcategory.destroy
    prods.each do |prod|
      expect(prod.sub_category).to eq(nil)
    end
  end
end
