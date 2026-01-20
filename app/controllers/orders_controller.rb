class OrdersController < ApplicationController
  # SSL認証エラー回避
  require 'openssl'
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE if Rails.env.development?

  # 未ログイン時のアクセス制限
  before_action :authenticate_user! 
  # 共通の@item取得処理
  before_action :set_item, only: [:index, :create]

  def index
    @order_address = OrderAddress.new
    # JavaScript側に公開鍵を渡す
    # gon.public_key = ENV['PAYJP_PUBLIC_KEY']
    gon.public_key = PAYJP_PUBLIC_KEY
  end

  def create
    @order_address = OrderAddress.new(order_params)
    if @order_address.valid?
      pay_item
      @order_address.save
      redirect_to root_path
    else
      # エラーで再描画する際も、JavaScriptが動くように鍵を渡す
      gon.public_key = ENV['PAYJP_PUBLIC_KEY']
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  end

  def order_params
    params.require(:order_address).permit(
      :postal_code, :prefecture_id, :city, :house_number, :building_name, :phone_number
    ).merge(
      user_id: current_user.id,
      item_id: params[:item_id],
      token: params[:token]
    )
  end

  def pay_item
    # Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
    Payjp.api_key = PAYJP_SECRET_KEY
    Payjp::Charge.create(
      amount: @item.price,
      card: order_params[:token],
      currency: 'jpy'
    )
  end
end