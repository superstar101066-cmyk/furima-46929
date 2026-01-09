require 'rails_helper'

RSpec.describe User, type: :model do
  before do # テスト用のユーザーオブジェクトを生成
    @user = FactoryBot.build(:user) # FactoryBotで定義したユーザーファクトリを呼び出し
  end

  describe 'ユーザー新規登録' do # ユーザー新規登録に関するテスト
    context '新規登録できるとき' do # 登録がうまくいくときの条件
      it 'すべての項目が正しく入力されていれば登録できる' do
        expect(@user).to be_valid # userオブジェクトが有効であることを期待
      end
    end

    # 登録がうまくいかないときの条件
    context '新規登録できないとき' do
      it 'nicknameが空では登録できない' do
        # nickname属性を空に設定
        @user.nickname = ''
        # バリデーションを実行
        @user.valid?
        # エラーメッセージに期待される文言が含まれていることを確認
        expect(@user.errors.full_messages).to include("Nickname can't be blank")
      end

      it 'emailが空では登録できない' do
        # email属性を空に設定
        @user.email = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Email can't be blank")
      end

      it 'passwordが空では登録できない' do
        # password属性を空に設定
        @user.password = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Password can't be blank")
      end

      it 'passwordが5文字以下では登録できない' do
        # password属性を5文字以下に設定
        @user.password = '12345'
        @user.password_confirmation = '12345'
        @user.valid?
        expect(@user.errors.full_messages).to include('Password is too short (minimum is 6 characters)')
      end

      it 'passwordが129文字以上では登録できない' do
        # password属性を129文字以上に設定
        @user.password = Faker::Internet.password(min_length: 129, max_length: 150)
        # password_confirmation属性も同じ値に設定
        @user.password_confirmation = @user.password
        @user.valid?
        expect(@user.errors.full_messages).to include('Password is too long (maximum is 128 characters)')
      end

      it 'passwordが英字のみでは登録できない' do
        # password属性に英字のみを設定
        @user.password = 'abcdef'
        @user.password_confirmation = 'abcdef'
        @user.valid?
        expect(@user.errors.full_messages).to include('Password is invalid')
      end

      it 'passwordが数字のみでは登録できない' do
        # password属性に数字のみを設定
        @user.password = '123456'
        @user.password_confirmation = '123456'
        @user.valid?
        expect(@user.errors.full_messages).to include('Password is invalid')
      end

      it 'passwordに全角文字を含むと登録できない' do
        # password属性に全角文字を含む値を設定
        @user.password = 'ａｂｃ123'
        @user.password_confirmation = 'ａｂｃ123'
        @user.valid?
        expect(@user.errors.full_messages).to include('Password is invalid')
      end

      it 'passwordとpassword_confirmationが不一致では登録できない' do
        # passwordとpassword_confirmation属性に異なる値を設定
        @user.password = '123456'
        # password_confirmation属性に異なる値を設定
        @user.password_confirmation = '1234567'
        @user.valid?
        expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
      end
      it 'last_nameが空では登録できない' do
        # last_name属性を空に設定
        @user.last_name = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Last name can't be blank")
      end

      it 'first_nameが空では登録できない' do
        # first_name属性を空に設定
        @user.first_name = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("First name can't be blank")
      end

      it 'last_nameが全角（漢字・ひらがな・カタカナ）でないと登録できない' do
        # last_name属性に半角英字の値を設定
        @user.last_name = 'abc'
        @user.valid?
        expect(@user.errors.full_messages).to include('Last name is invalid')
      end

      it 'first_nameが全角（漢字・ひらがな・カタカナ）でないと登録できない' do
        # first_name属性に半角英字の値を設定
        @user.first_name = 'abc'
        @user.valid?
        expect(@user.errors.full_messages).to include('First name is invalid')
      end

      it 'last_name_kanaが空では登録できない' do
        # last_name_kana属性を空に設定
        @user.last_name_kana = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Last name kana can't be blank")
      end

      it 'first_name_kanaが空では登録できない' do
        # first_name_kana属性を空に設定
        @user.first_name_kana = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("First name kana can't be blank")
      end

      it 'last_name_kanaが全角（カタカナ）でないと登録できない' do
        # last_name_kana属性に全角（ひらがな）の値を設定
        @user.last_name_kana = 'あいうえお'
        @user.valid?
        expect(@user.errors.full_messages).to include('Last name kana is invalid')
      end

      it 'first_name_kanaが全角（カタカナ）でないと登録できない' do
        # first_name_kana属性に全角（ひらがな）の値を設定
        @user.first_name_kana = 'あいうえお'
        @user.valid?
        expect(@user.errors.full_messages).to include('First name kana is invalid')
      end

      it 'birth_dateが空では登録できない' do
        # birth_date属性を空に設定
        @user.birth_date = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Birth date can't be blank")
      end

      it '重複したemailが存在する場合登録できない' do
        # 既に保存されているユーザーのemailを使用して新しいユーザーを作成
        @user.save # ← ここで一度データベースに保存している！
        another_user = FactoryBot.build(:user, email: @user.email) # 同じメアドを持つ別の人間を用意
        another_user.valid?
        expect(another_user.errors.full_messages).to include('Email has already been taken')
      end

      it 'emailに@を含まない場合は登録できない' do
        # email属性に@を含まない値を設定
        @user.email = 'testmail.com'
        @user.valid?
        expect(@user.errors.full_messages).to include('Email is invalid')
      end
    end
  end
end
