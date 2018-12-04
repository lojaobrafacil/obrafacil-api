require 'rails_helper'

RSpec.describe Log::PremioIdeal, type: :model do
  let(:log_premio_ideal) { build(:log_premio_ideal) }

  it { should belong_to(:partner) }
end
