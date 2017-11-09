require 'rails_helper'

RSpec.describe Price, type: :model do
  let(:price) { create(:price) }

  it 'validate uniqueness of product scoped to kind' do
    product = create(:product)
    price = create(:price, product_id: product.id)
    p = build(:price, product_id: product.id, kind: price.kind)
    p.save
    expect(p.errors.messages).to include(:product_id)
    p.kind = price.kind+1
    expect(p.save).to eq(true)
  end
  it { is_expected.to validate_numericality_of(:kind) }
  it { should belong_to(:product) }
end
