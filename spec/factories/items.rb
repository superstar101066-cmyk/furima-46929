FactoryBot.define do
  # 出品できるときのデータ
  factory :item do
    item_name                 { 'テスト商品' }
    description               { 'テストの説明' }
    category_id               { 2 }
    item_status_id            { 2 }
    shipping_fee_liability_id { 2 }
    prefecture_id             { 2 }
    shipping_date_status_id   { 2 }
    price                     { 1000 }
    association :user

    # 画像の添付
    after(:build) do |item| # build後に画像を添付する
      item.image.attach(io: File.open('public/images/test_image.png'), filename: 'test_image.png', content_type: 'image/png')
    end
  end
end

# after(:build) : インスタンスがメモリ上に作られた(buildされた)後に特定の処理を実行するためのFactoryBotのコールバックメソッド(予約命令）。
# ここでは、Itemモデルのインスタンスがbuildされた直後に、画像を添付する処理を実行している。
# item.image.attach(...) : Active Storageのメソッドで、画像ファイルをモデルのimage属性に添付している。
# io: File.open('public/images/test_image.png') : 添付する画像ファイルを指定しており、今回は、プロジェクトのpublic/imagesディレクトリにあるtest_image.pngファイルを開いている。
# filename: 'test_image.png' : 添付する画像のファイル名を指定している。
# content_type: 'image/png' : 添付する画像のMIMEタイプを指定している。
# FactoryBot: Railsアプリケーションでテストデータを簡単に作成・管理するためのライブラリ。
# コールバックメソッド: FactoryBotの特定のタイミングで処理を実行するための予約命令。
# Active Storage: Railsの組み込み機能で、ファイルのアップロードと管理を簡単に行うための仕組み。
# MIMEタイプ: ファイルの種類を示す識別子。例えば、画像ファイルの場合は "image/png" や "image/jpeg" などがある。
