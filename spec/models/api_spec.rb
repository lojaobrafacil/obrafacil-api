require 'rails_helper'

RSpec.describe Api, type: :model do
  let(:api) { build(:api) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:federal_registration) }

  it "generate_new_tokens!" do
    @api = Api.new(attributes_for(:api))
    expect(@api.access_id).to eq(nil)
    expect(@api.access_key).to eq(nil)
    @api.valid?
    expect(@api.access_id).not_to eq(nil)
    expect(@api.access_key).not_to eq(nil)
  end
end
