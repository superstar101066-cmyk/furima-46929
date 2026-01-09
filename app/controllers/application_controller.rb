class ApplicationController < ActionController::Base
  before_action :basic_auth
  # Deviseのコントローラーが動くとき、パラメーター許可のメソッドを実行する
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["BASIC_AUTH_USER"] && password == ENV["BASIC_AUTH_PASSWORD"]
    end
  end

  def configure_permitted_parameters #パラメータ許可のメソッドを定義
    # 新規登録時に、設計した追加カラムを許可する
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname, :last_name, :first_name, :last_name_kana, :first_name_kana, :birth_date])
  end
end

    # devise_parameter_sanitizer	Devise専用の「門番（パラメーターをチェックする人）」
    # permit	許可する
    # :sign_up	新規登録のとき
    # keys:[...]	許可したいカラム名のリスト