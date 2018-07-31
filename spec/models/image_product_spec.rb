require 'rails_helper'

RSpec.describe ImageProduct, type: :model do
  let (:image_product) { create(:image_product) }

  it { should belong_to(:product) }
  it { should validate_presence_of(:attachment) }
  

end
