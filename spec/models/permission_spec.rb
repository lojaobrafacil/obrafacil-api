require 'rails_helper'

RSpec.describe Permission, type: :model do
  let(:permission) { build(:permission) }

  it { is_expected.to validate_presence_of(:name) }
end
