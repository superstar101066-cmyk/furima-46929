FactoryBot.define do
  factory :item do
    item_name              {"テスト商品"}
    description            {"テストの説明"}
    category_id            {2}
    item_status_id         {2}
    shipping_fee_liability_id {2}
    prefecture_id          {2}
    shipping_date_status_id {2}
    price                  {1000}
    association :user

    after(:build) do |item|
      item.image.attach(io: File.open('public/images/test_image.png'), filename: 'test_image.png', content_type: 'image/png')
    end
  end
end