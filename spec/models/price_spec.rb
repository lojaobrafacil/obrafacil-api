require "rails_helper"

RSpec.describe Price, type: :model do
  let(:price) { create(:price) }

  it "validate uniqueness of company_product scoped to kind" do
    company_product = create(:company_product)
    price = create(:price, company_product_id: company_product.id)
    p = build(:price, company_product_id: company_product.id, kind: price.kind)
    p.save
    expect(p.errors.messages).to include(:company_product_id)
    p.kind = price.kind + 1
    expect(p.save).to eq(true)
  end
  it { is_expected.to validate_numericality_of(:kind) }
  it { should belong_to(:company_product) }
end
