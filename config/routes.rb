Rails.application.routes.draw do
  devise_for :users
  root to: 'items#index' #一覧表示ページを表示する
  #itemsコントローラーのアクションに対応するルーティングを設定
  resources :items do # itemsリソースに対してordersリソースをネストさせる
    #ordersコントローラーのnew,createアクションに対応するルーティングを設定
    resources :orders, only: [:index, :create]
  end
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

# ネストとは、入れ子構造のように、あるリソースが他のリソースの内部に位置する関係を表現する方法。
# 入れ子構造とは、ある要素が別の要素の中に含まれている構造のことを指す。
# ネストは、親子関係に似ており、親リソースが子リソースを包含する形となる。
# 親がitemsリソースであり、子がordersリソースである。
# 今回の場合、ordersリソースはitemsリソースの中にネストされている。
# これにより、ordersリソースは特定のitemに関連付けられることを示している。
# 具体的には、itemsリソースの中にordersリソースを含めることで、特定の商品（item）に対して購入情報（order）を関連付けることができる。
  # 例えば、ある商品（item）に対して購入情報（order）を作成する場合、その商品に関連するordersリソースを扱うことができる。
# ルーティングにおいてネストを使用することで、URLパスが階層的に表現され、リソース間の関係性が明確になる。
  # 例えば、itemsリソースにネストされたordersリソースのURLパスは、/items/:item_id/ordersのようになる。
# ここで、:item_idは特定の商品（item）のIDを示し、その商品に関連する購入情報（order）を扱うことができる。
# モデルにおけるアソシエーション設定でも、ネストの概念が反映される。
# ItemモデルとOrderモデルの関係性を考えると、Itemモデルは出品した商品を表し、Orderモデルは購入情報を表す。
# ItemモデルはOrderモデルに対して1対1の関係を持つため、Itemモデルにhas_one :orderというアソシエーションを設定する。