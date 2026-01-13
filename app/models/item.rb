class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  belongs_to :item_status
  belongs_to :shipping_fee_liability
  belongs_to :prefecture
  belongs_to :shipping_date_status

  belongs_to :user
  has_one_attached :image
end