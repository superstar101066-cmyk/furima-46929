FactoryBot.define do
  factory :item do
    item_name { "MyString" }
    description { "MyText" }
    category_id { 1 }
    item_status_id { 1 }
    shipping_fee_liability_id { 1 }
    prefecture_id { 1 }
    shipping_date_status_id { 1 }
    price { 1 }
    user { nil }
  end
end
