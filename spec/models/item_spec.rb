require 'rails_helper'

RSpec.describe Item, type: :model do
  before do
    @item = FactoryBot.build(:item)
  end

  describe '商品出品機能' do
    context '出品できるとき' do
      it '全ての項目が存在すれば登録できる' do
        expect(@item).to be_valid
      end
    end

    context '出品できないとき' do
      # --- 基本項目の空チェック ---
      it 'imageが空では保存できない' do
        @item.image = nil # 画像をnilに設定
        @item.valid? # バリデーションを実行
        expect(@item.errors.full_messages).to include("Image can't be blank") # エラーメッセージの確認
      end

      # --- ActiveHashの「---」選択チェック (id: 1 のとき) ---
      it 'category_idが1では保存できない' do
        @item.category_id = 1 # category_idを1に設定
        @item.valid?
        expect(@item.errors.full_messages).to include("Category can't be blank")
      end

      it 'item_status_idが1では保存できない' do
        @item.item_status_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include("Item status can't be blank")
      end

      it 'shipping_fee_liability_idが1では保存できない' do
        @item.shipping_fee_liability_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include("Shipping fee liability can't be blank")
      end

      it 'prefecture_idが1では保存できない' do
        @item.prefecture_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include("Prefecture can't be blank")
      end

      it 'shipping_date_status_idが1では保存できない' do
        @item.shipping_date_status_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include("Shipping date status can't be blank")
      end

      # --- 価格の数値・範囲チェック ---
      it 'priceが300未満では保存できない' do
        @item.price = 299 # 価格を299に設定
        @item.valid?
        expect(@item.errors.full_messages).to include("Price must be greater than or equal to 300")
      end

      it 'priceが10,000,000以上では保存できない' do
        @item.price = 10_000_000 # 価格を10,000,000に設定
        @item.valid?
        expect(@item.errors.full_messages).to include("Price must be less than or equal to 9999999")
      end

      it 'item_nameが空では保存できない' do
        @item.item_name = '' # 商品名を空に設定
        @item.valid?
        expect(@item.errors.full_messages).to include("Item name can't be blank")
      end

      # 商品情報
      it 'descriptionが空では保存できない' do
        @item.description = '' # 商品説明を空に設定
        @item.valid?
        expect(@item.errors.full_messages).to include("Description can't be blank")
      end

      it 'priceが空では保存できない' do
        @item.price = nil # 価格を空に設定
        @item.valid?
        expect(@item.errors.full_messages).to include("Price can't be blank")
      end

      it 'priceが半角数値以外では保存できない' do
        @item.price = '１０００' # 価格の値を全角に設定
        @item.valid?
        expect(@item.errors.full_messages).to include("Price is not a number")
      end

      it 'userが紐付いていないと保存できない' do
        @item.user = nil # userを紐付けない
        @item.valid?
        expect(@item.errors.full_messages).to include('User must exist')
      end

    end
  end
end  