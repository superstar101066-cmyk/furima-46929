class OrdersController < ApplicationController
  # 未ログイン時のアクセス制限。フィルタを適用し堅牢性を確保
  before_action :authenticate_user! 
  # indexとcreateが動く前に、対象の商品情報をDBから見つけてきて変数@itemに入れておく
  before_action :set_item, only: [:index, :create]

  def index # 購入情報入力ページを表示する
    # ネストされたitemの情報を取得
    @item = Item.find(params[:item_id])
    # 購入情報と発送先住所情報を同時に保存するためのフォームオブジェクトを生成後、変数に代入してビューに渡す
    @order_address = OrderAddress.new
    # JavaScript側でPAY.JPを起動するために、環境変数の「公開鍵」をgon経由で渡す
    gon.public_key = ENV['PAYJP_PUBLIC_KEY']
  end

  def create # 購入情報を保存する
    # ユーザーが入力した情報（住所やトークン）をFormオブジェクトの箱に詰める
    @order_address = OrderAddress.new(order_params)
    if @order_address.valid? # もし入力内容にミスがない場合は（バリデーションチェック）
      pay_item # 決済を実行（Payjp::Charge.createを呼び出し）
      @order_address.save # 決済が成功したら、DB（ordersテーブルとaddressesテーブル）に保存
      redirect_to root_path # 処理が完了したらトップページへ戻す
    else # もし入力内容にミスがある場合は
      # PAY.JPの鍵を再定義する（購入ページ再表示の際も公開鍵が必要であるため）
      gon.public_key = ENV["PAYJP_PUBLIC_KEY"] 
      render :index, status: :unprocessable_entity # 購入ページを再表示する
    end
  end

  private
  # PAY.JP API連携：決済ロジックをコントローラー内で分離
  def set_item
    @item = Item.find(params[:item_id])
  end

  # ユーザーが送ってきたデータを精査し、必要なものだけを許可する
  def order_params
    # 住所情報などを許可しつつ、ログインユーザーのID、商品のID、カードトークンを一つに合体（merge）させる
    params.require(:order_address).permit(:postal_code, :prefecture_id, :city, :house_number, :building_name, :phone_number).merge(user_id: current_user.id, item_id: params[:item_id], token: params[:token])
  end

  # PAY.JP API連携：決済ロジックをコントローラー内で分離
  def pay_item
    # 環境変数から自分の「秘密鍵」をセット（これがないと本人確認ができない）
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"] # 自身の秘密鍵

    # 外部サービス（PAY.JP）へ決済リクエストを送信
    Payjp::Charge.create(
      amount: @item.price,           # DBの価格情報を元に決済額を決定
      card: order_params[:token],    # クライアントサイドでトークン化した決済情報を利用
      currency: 'jpy'                # 日本円指定
    )
  end
end

# gonとは、RailsのコントローラーからJavaScriptにデータを渡すためのgemである。
# gonを使用することで、Railsのインスタンス変数やその他のデータをJavaScript側で簡単に利用できるようになる。
# 例えば、コントローラー内で gon.variable_name = value と設定すると、その値がJavaScript側で gon.variable_name としてアクセスできるようになる。
# これにより、サーバーサイドで計算や取得したデータをクライアントサイドのJavaScriptで利用することが容易になる。
# PAY.JPは、日本で広く利用されているオンライン決済サービスであり、クレジットカード決済を簡単に導入できるプラットフォームを提供している。
# PAY.JPを使用することで、ウェブサイトやアプリケーションに安全かつ迅速な決済機能を組み込むことができる。
# PAY.JPの主な特徴には、以下のようなものがある。
  # 1. 簡単な導入: PAY.JPは、APIやSDKを提供しており、開発者が迅速に決済機能を実装できるようにしている。
  # 2. 多様な決済方法: クレジットカード決済をはじめ、コンビニ決済や銀行振込など、複数の決済方法に対応している。
  # 3. セキュリティ: PCI DSS準拠のセキュリティ基準を満たしており、安全な決済環境を提供している。
  # 4. 管理画面: 取引履歴の確認や売上管理ができる管理画面を提供している。
  # 5. 定期課金: サブスクリプションモデルのビジネスに対応するための定期課金機能も提供している。
# PAY.JPは、特に日本国内のオンラインビジネスにおいて広く利用されており、多くの企業や個人がその決済ソリューションを採用している。