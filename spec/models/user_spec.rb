require 'rails_helper'

RSpec.describe User, type: :model do
	let(:user) { build(:user) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to allow_value('arthur@moura.com').for(:email) }
  it { is_expected.to validate_uniqueness_of(:auth_token) }
	it { should have_one(:client) }
	it { should have_one(:partner) }
	it { should have_one(:company) }


  # describe '#generate_authentication_token!' do
  #   it 'generates a unique auth token' do
  #     allow(Devise).to receive(:friendly_token).and_return('abc123xyzTOKEN')
  #     user.generate_authentication_token!
  #
  #     expect(user.auth_token).to eq('abc123xyzTOKEN')
  #   end
  #
  #   it 'generates another auth token when the current auth token already has been taken' do
  #     existing_user = create(:user, auth_token: 'abc123tokenxyz')
  #     allow(Devise).to receive(:friendly_token).and_return('abc123tokenxyz', 'abc123tokenxyz', 'abcXYZ123456789')
  #     user.generate_authentication_token!
  #
  #     expect(user.auth_token).not_to eq(existing_user.auth_token)
  #   end
  # end
end
