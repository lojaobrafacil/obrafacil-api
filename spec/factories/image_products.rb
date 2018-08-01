FactoryBot.define do
	factory :image_product do
		product_id { create(:product).id }
		attachment { File.new(Rails.root + ('spec/images/test_image.jpg'))}
	end
end
