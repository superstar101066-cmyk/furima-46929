class User < ApplicationRecord
# Deviseのデフォルト設定
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

# 1. 基本情報のバリデーション（空文字を禁止）
  validates :nickname, presence: true 
  validates :birth_date, presence: true

# 2. パスワードのバリデーション（半角英数字混合）
# パスワード（確認用）との一致は Devise が自動で行うため、フォーマットのみ追加
  validates :password, format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i }

# 3. 本人情報（名前全角）のバリデーション
  with_options presence: true, format: { with: /\A[ぁ-んァ-ヶ一-龥々ー]+\z/ } do
    validates :last_name
    validates :first_name
  end

# 4. 本人情報（名前カナ全角）のバリデーション
  with_options presence: true, format: { with: /\A[ァ-ヶー]+\z/ } do
    validates :last_name_kana
    validates :first_name_kana
  end
end
