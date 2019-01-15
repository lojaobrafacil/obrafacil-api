require "rails_helper"

RSpec.describe Vehicle, type: :model do
  let (:vehicle) { create(:vahicle) }

  it { is_expected.to validate_presence_of(:model) }
  it { is_expected.to validate_presence_of(:brand) }
end
