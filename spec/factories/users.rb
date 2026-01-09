FactoryBot.define do
  factory :user do
    # Fakerを使って、ランダムな2文字のイニシャルを生成
    nickname { Faker::Name.initials(number: 2) }

    # Fakerを使って、ランダムな形式のメールアドレスを生成
    email                 { Faker::Internet.email }

    # '1a'という固定文字にランダムなパスワードを組み合わせて「英数字混合」を確実に作る
    password              { "1a#{Faker::Internet.password(min_length: 6)}" }

    # 上記で生成されたpasswordと同じ値をセットする
    password_confirmation { password }

    # 漢字・ひらがな・カタカナのバリデーションを通過させるための固定値
    last_name             { '山田' }
    first_name            { '太郎' }

    # 全角カタカナのバリデーションを通過させるための固定値
    last_name_kana        { 'ヤマダ' }
    first_name_kana       { 'タロウ' }

    # Fakerを使って、過去のランダムな日付を生成
    birth_date            { Faker::Date.backward }
  end
end
