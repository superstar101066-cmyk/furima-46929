Rails.application.routes.draw do
  devise_for :users
  root to: 'items#index' #一覧表示ページを表示する
  #itemsコントローラーのindex,new,createアクションに対応するルーティングを設定
  resources :items, only: [:index,:new, :create]
end

#localhost用： ⑴ HTTPメソッド ⑵ 'URIパターン', to: ⑶ 'コントローラー名 ⑷#アクション名  ['get '/items', to: 'items#index']
  #Render用：    ⑸ ルートパス: '⑶ コントローラー名 ⑷#アクション名  [root to: 'items#index']

  # ⑴ HTTPメソッド
      # get:情報取得  post:情報作成  patch:情報更新  put:情報更新  delete:情報削除
  # ⑵ URIパターン
    #/items
  # ⑶ コントローラー名
    #itemsコントローラー
  # ⑷アクション名
    #index:一覧表示ページを表示する  new:新規登録ページを表示する  create:新規登録の保存  show:詳細表示ページを表示する  edit:編集ページを表示する  update:編集の保存  destroy:削除
  # ⑸ルートパス  /にアクセスした際に表示されるページ
    # root to: 