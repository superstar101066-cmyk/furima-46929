Rails.application.routes.draw do
  #HTTPメソッド 'URIパターン', to: 'コントローラー名#アクション名'
  get '/items', to: 'items#index' #一覧表示ページを表示する
end

#HTTPメソッド
#get    情報取得
#post   情報作成
#patch  情報更新
#put    情報更新
#delete 情報削除

#URIパターン
#/items

#コントローラー名
#itemsコントローラー

#アクション名
#index   一覧表示ページを表示する
#new     新規登録ページを表示する
#create  新規登録の保存
#show    詳細表示ページを表示する
#edit    編集ページを表示する
#update  編集の保存
#destroy 削除