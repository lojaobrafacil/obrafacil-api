require 'rails_helper'

RSpec.describe User, type: :model do
	let(:user) { build(:user) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to allow_value("arthur@moura.com").for(:email) }

end
