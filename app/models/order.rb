class Order < ApplicationRecord
  # アソシエーション設定
  belongs_to :user # 購入した商品とユーザーの関係は多対1
  belongs_to :item # 購入した商品と出品した商品の関係は多対1
  has_one :address # 購入した商品と発送先住所情報の関係は1対1
end
