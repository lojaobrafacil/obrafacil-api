FactoryBot.define do
  factory :email do
    email { Faker::Internet.email }
    email_type_id { create(:email_type).id }
    association :emailable, :factory => :client
  end
end
