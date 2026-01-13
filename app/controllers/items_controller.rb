class ItemsController < ApplicationController
  # ログインしていないユーザーはログインページにリダイレクト（index以外）
  before_action :authenticate_user!, except: [:index]

  def index
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

  private

  def item_params
    params.require(:item).permit(
      :image, :item_name, :description, :category_id, :item_status_id,
      :shipping_fee_liability_id, :prefecture_id, :shipping_date_status_id, :price
    ).merge(user_id: current_user.id)
  end
end

