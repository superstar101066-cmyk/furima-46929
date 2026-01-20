# 「購入記録（ordersテーブル）」と「住所（addressesテーブル）」の2つにデータを振り分けて保存する役割を持つモデル
class OrderAddress
  # ActiveModelを利用してバリデーションなどの機能を使用できるようにする
  include ActiveModel::Model
  # 保存したい全てのカラム ＋ 決済用トークンの属性を定義
  attr_accessor :user_id, :item_id, :postal_code, :prefecture_id, :city, :house_number, :building_name, :phone_number, :token

  # 購入者情報にバリデーションを設定
  with_options presence: true do # 全ての属性に対してpresence: true(空の投稿を保存できない）を適用
    validates :user_id # ユーザーIDのバリデーション
    validates :item_id # 商品IDのバリデーション
    # 郵便番号のバリデーション (ハイフンありの形式のみ許可)
    validates :postal_code, format: {with: /\A[0-9]{3}-[0-9]{4}\z/, message: "is invalid. Enter it as follows (e.g. 123-4567)"}
    # 都道府県IDのバリデーション (---を選択したまま保存されるのを防ぐ)
    validates :prefecture_id, numericality: {other_than: 1, message: "can't be blank"}
    validates :city # 市区町村のバリデーション
    validates :house_number # 番地のバリデーション
    # 電話番号のバリデーション (ハイフンなしの10桁or11桁の数値のみ許可)
    validates :phone_number, format: {with: /\A[0-9]{10,11}\z/, message: "is invalid. Input only number"}
    validates :token # PAY.JPからの決済用トークンを受け取るための属性
  end

  def save # 購入記録と住所情報を保存するメソッド
    # 購入記録(orders)を保存し、変数orderに代入
    order = Order.create(user_id: user_id, item_id: item_id)
    # 配送先(addresses)を保存
    Address.create(
      postal_code: postal_code, # 郵便番号
      prefecture_id: prefecture_id, # 都道府県ID
      city: city, # 市区町村
      house_number: house_number, # 番地
      building_name: building_name, # 建物名
      phone_number: phone_number, # 電話番号
      order_id: order.id # 購入記録ID
    )
  end
end

# ActiveModel::Modelを利用することで、通常のRailsモデルと同様にバリデーションやフォームオブジェクトとしての機能を利用できる。
# attr_accessorとは、Rubyのメソッドで、指定した属性に対して読み取りと書き込みの両方のメソッドを自動的に生成する。
# attr_accessorで定義した属性は、フォームから送信されたデータを受け取るために使用される。
# attr_accessor :user_id, :item_id, :postal_code, :prefecture_id, :city, :house_number, :building_name, :phone_number, :token
# これにより、OrderAddressオブジェクトはこれらの属性を持ち、値の取得と設定が可能になる。
# with_optionsは、共通のオプションをまとめて適用するための便利な方法であり、コードの重複を減らすことができる。
# with_options presence: true do ... endを使用して、複数の属性に対して一括でpresence: trueのバリデーションを適用している。

# saveメソッド内では、まずOrderモデルを使用して購入記録を保存し、その後Addressモデルを使用して配送先住所を保存している。
# これにより、1つのフォームから複数のテーブルにデータを保存することができる。
# Order.create(...)は、Orderモデルの新しいレコードを作成し、データベースに保存する。
# Address.create(...)は、Addressモデルの新しいレコードを作成し、データベースに保存する。