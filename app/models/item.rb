class Item < ApplicationRecord
  # ActiveHashのアソシエーション設定
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category 
  belongs_to :item_status
  belongs_to :shipping_fee_liability
  belongs_to :prefecture
  belongs_to :shipping_date_status

  # userモデルとのアソシエーション設定
  belongs_to :user
  # データベースにはimageカラムは存在しないが、Active Storageで画像を扱うための設定
  # モデル（item.rb）に has_one_attached :image と記述したことで、
  # あたかも image というカラムがあるかのように Rails上で扱うことができるようになる
  has_one_attached :image
end