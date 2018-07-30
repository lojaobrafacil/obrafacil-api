FactoryBot.define do
    factory :vehicle do
      brand { Faker::FunnyName.name }
      model { Faker::FunnyName.two_word_name }
    end
  end
  