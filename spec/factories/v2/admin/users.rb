FactoryBot.define do
	factory :user do
		email { Faker::Internet.email }
		password '12345678'
		password_confirmation '12345678'
		kind 0
		federal_registration { Faker::Code.isbn }
	end
end
