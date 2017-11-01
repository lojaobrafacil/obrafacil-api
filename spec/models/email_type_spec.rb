require 'rails_helper'

RSpec.describe EmailType, type: :model do
  let(:emailtype) { build(:email_type) }

  it { is_expected.to validate_presence_of(:name) }
end
