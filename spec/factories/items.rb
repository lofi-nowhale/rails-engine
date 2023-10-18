FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence }
    unit_price { Faker::Commerce.price(range: 1..300.0) }
    merchant_id { Faker::Number.within(range: 1..5) }
  end
end
