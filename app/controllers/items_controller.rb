class ItemsController < ApplicationController
  # ログインしていないユーザーはログインページにリダイレクト（index,show以外）
  before_action :authenticate_user!, except: [:index, :show]

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
    @item = Item.find(params[:id]) # 詳細ページ用のインスタンス変数
  end

  private

  def item_params
    params.require(:item).permit(
      :image, :item_name, :description, :category_id, :item_status_id,
      :shipping_fee_liability_id, :prefecture_id, :shipping_date_status_id, :price
    ).merge(user_id: current_user.id)
  end
end

# Item.allとは、データベースの items（商品）テーブルにあるすべてのレコードを取得すること
# order("created_at DESC")とは、取得したレコードを作成日時（created_at）が新しい順（降順）に並べ替えること
# created_atは、「作成日時」のカラムを指す
# DESCは「降順」を意味し、新しいもの（大きい値）から古いもの（小さい値）へと順に並べることを指す
# Item.find(params[:id])とは、URLの末尾に含まれるidパラメーターを使って、特定の商品のレコードをデータベースから取得すること
