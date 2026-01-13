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

  # 空の投稿を保存できないようにする
  validates :image, :item_name, :description, :category_id, :item_status_id,
            :shipping_fee_liability_id, :prefecture_id, :shipping_date_status_id,
            :price, presence: true

  # ジャンルの選択が「---」(id: 1)の時は保存できないようにする
  validates :category_id, :item_status_id, :shipping_fee_liability_id,
            :prefecture_id, :shipping_date_status_id,
            numericality: { other_than: 1, message: "can't be blank" }

  # 価格の範囲（¥300~¥9,999,999）と数値のみの保存を制限
  # half-width numbers: 半角数値のみ
  validates :price, numericality: { only_integer: true, greater_than_or_equal_to: 300, less_than_or_equal_to: 9_999_999 }
end

# presence: true: nil (何もデータがない)や空文字 ( "" や " " のようなスペースのみの状態)を許可しない。
# validates :image, presence: true とすることで、画像が添付されていない場合にエラーにできる。
# numericality: true: 数値のみを許可する。(300.5などの小数も許可される)
# numericality: { only_integer: true }: 整数のみを許可する。(300.5などの小数は許可されない)
# numericality: { other_than: 1 }: ActiveHashの初期値「---」を選択したまま保存されるのを防ぐ。
# 価格の制限
# only_integer: true: 小数を許可せず、整数（半角数値）のみにする。
# greater_than_or_equal_to: 300: 300以上に制限する。
# less_than_or_equal_to: 9_999_999: 9,999,999以下に制限する。
