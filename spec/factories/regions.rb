FactoryBot.define do
  factory :region do
    name { ['Norte','Sul','Leste','Oeste'].sample }
  end
end
