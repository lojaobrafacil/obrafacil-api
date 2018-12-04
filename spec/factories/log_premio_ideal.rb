FactoryBot.define do
  factory :log_premio_ideal do
    status { 200 }
    error { "ok" }
    body { attributes_for(:partner).as_json }
  end
end
