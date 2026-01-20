const pay = () => {
  // Railsのコントローラーで設定した公開鍵（gon.public_key）を変数に代入
  const publicKey = gon.public_key
  // 公開鍵を使って、PAY.JPの決済システムをこのページで使えるように初期化
  const payjp = Payjp(publicKey) // PAY.JP初期化
  // 入力フォームを作るための「土台（elements）」を作成
  const elements = payjp.elements();

  // カード番号、有効期限、CVC（セキュリティコード）のそれぞれの入力フォームパーツを作成
  const numberElement = elements.create('cardNumber');
  const expiryElement = elements.create('cardExpiry');
  const cvcElement = elements.create('cardCvc');

  // HTML上の指定したID（#number-formなど）の場所に、PAY.JPが作った入力フォームをはめ込む（表示させる）
  numberElement.mount('#number-form');
  expiryElement.mount('#expiry-form');
  cvcElement.mount('#cvc-form');

  // 購入ボタンが押された（フォームが送信されようとした）時の動作を定義
  const form = document.getElementById('charge-form');
  form.addEventListener("submit", (e) => {
    // PAY.JPのサーバーにカード情報を送り、トークン（暗号化された文字列）の作成を依頼
    payjp.createToken(numberElement).then(function (response) {
      if (response.error) {
        // エラー（カード番号間違いなど）があった場合は、ここでは特に何もしない（そのままRailsへ送る）
      } else {
        // 成功した場合、レスポンスからトークン（response.id）を取り出す
        const token = response.id;
        // Railsにトークンを送るために、HTMLのフォームの中に「隠し入力欄（hidden）」を追加する
        const renderDom = document.getElementById("charge-form");
        const tokenObj = `<input value=${token} name='token' type="hidden">`; // ユーザーには見えない入力欄
        renderDom.insertAdjacentHTML("beforeend", tokenObj);
      }

      // 入力されたカード情報をブラウザ上のフォームから消去する（セキュリティのため）
      numberElement.clear();
      expiryElement.clear();
      cvcElement.clear();

      // Railsのサーバー（コントローラーのcreateアクション）にフォームの情報を送信
      document.getElementById("charge-form").submit();
    });

    // 通常の送信処理（Railsへ直接送る動作）を一旦キャンセルする
    // これをしないと、トークンができる前にRailsに情報が送られてしまうため
    e.preventDefault();
  });
};

// window（ブラウザの画面全体）が、全てのデータの読み込みを完了（load）した時に、
// 最初に定義した「pay」という一連の処理を実行するように命令している。
window.addEventListener("load", pay);