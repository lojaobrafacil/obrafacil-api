require "rails_helper"

RSpec.describe Commission, type: :model do
  it { should belong_to(:partner) }
end
