class ItemsController < ApplicationController
  # ログインしていないユーザーはログインページにリダイレクト（index,show以外）
  before_action :authenticate_user!, except: [:index, :show]
  # 共通化：指定したアクションの前に商品情報を取得する
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  # 権限ガード：出品者本人でない場合はトップへ戻す
  before_action :move_to_index, only: [:edit, :update, :destroy]

  def index
    # 全ての商品を、作成日時が新しい順（降順）で取得
    @items = Item.all.order('created_at DESC')
  end

  def new
    @item = Item.new # form_with用のインスタンス変数
  end

  def create
    @item = Item.new(item_params) # ストロングパラメータでインスタンス生成
    if @item.save # 保存に成功した場合
      redirect_to root_path # indexページにリダイレクト
    else # 保存に失敗した場合
      # 保存失敗時は新規投稿ページに戻る。エラーメッセージ表示のため status を指定。
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # set_itemで取得した@itemを使用するためコメントアウト
  end

  def edit
    # set_itemで取得した@itemを使用するためコメントアウト
  end

  def update
    if @item.update(item_params) # 更新に成功した場合
      redirect_to item_path(@item) # 詳細ページにリダイレクト
    else # 更新に失敗した場合
      # 更新失敗時は編集ページに戻る。エラーメッセージ表示のため status を指定。
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
  
  if @item.destroy # 商品の削除に成功した場合
      redirect_to root_path # トップページにリダイレクト
  else # 商品の削除に失敗した場合
    # 削除失敗時は詳細ページに戻る。
    render :show, status: :unprocessable_entity
  end

  private
  
  # ストロングパラメータ
  def item_params
    params.require(:item).permit(
      :image, :item_name, :description, :category_id, :item_status_id,
      :shipping_fee_liability_id, :prefecture_id, :shipping_date_status_id, :price
    ).merge(user_id: current_user.id)
  end

  # 特定の商品を１件取得する共通メソッド
  def set_item
    @item = Item.find(params[:id])
  end

  # 出品者本人か確認し、違う場合はトップページにリダイレクトするメソッド
  def move_to_index
    # 出品者本人でなければトップページにリダイレクト
    unless current_user.id == @item.user_id
      redirect_to root_path
    end
  end
end

# before_actionとは、コントローラー内で特定のアクションが実行される前に指定したメソッドを呼び出すためのフィルタ機能
# authenticate_user!とは、Deviseが提供するメソッドで、ユーザーがログインしているかどうかを確認するためのもの
# except: [:index, :show]とは、指定したアクション（ここではindexとshow）を除外することを意味する
# item_paramsとは、ストロングパラメータを定義するためのプライベートメソッド
# params.require(:item)とは、paramsハッシュから:itemキーに対応する値を取得し、その値が存在しない場合はエラーを発生させること
# .permit(...)とは、指定した属性のみを許可し、それ以外の属性は無視すること
# .merge(user_id: current_user.id)とは、許可されたパラメータに現在ログインしているユーザーのIDを追加すること
# Item.allとは、データベースの items（商品）テーブルにあるすべてのレコードを取得すること
# order("created_at DESC")とは、取得したレコードを作成日時（created_at）が新しい順（降順）に並べ替えること
# created_atは、「作成日時」のカラムを指す
# DESCは「降順」を意味し、新しいもの（大きい値）から古いもの（小さい値）へと順に並べることを指す
# Item.find(params[:id])とは、URLの末尾に含まれるidパラメーターを使って、特定の商品のレコードをデータベースから取得すること
