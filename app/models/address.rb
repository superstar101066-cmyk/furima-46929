class Address < ApplicationRecord
  # アソシエーション設定
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :prefecture # 発送先住所情報と都道府県の関係は多対1

  belongs_to :order # 発送先住所情報と購入した商品の関係は多対1
end
