const pay = () => {
  if (!window.gon || !gon.public_key) {
    return;
  }
  const publicKey = gon.public_key; // ここで鍵を取得
  const payjp = Payjp(publicKey);
  const elements = payjp.elements();

  // カード情報の入力欄を作成
  const numberElement = elements.create('cardNumber');
  const expiryElement = elements.create('cardExpiry');
  const cvcElement = elements.create('cardCvc');

  numberElement.mount('#number-form');
  expiryElement.mount('#expiry-form');
  cvcElement.mount('#cvc-form');

  const form = document.getElementById('charge-form');

  form.addEventListener("submit", function sendForm(e) {
    e.preventDefault();

    payjp.createToken(numberElement).then(function (response) {
      
      if (response.error) {
        // エラーがある場合はログを出して確認
        // console.log("PAY.JP Error:", response.error);
      } else {
        const token = response.id;
        const renderDom = document.getElementById("charge-form");
        const tokenObj = `<input value="${token}" name="token" type="hidden">`;
        renderDom.insertAdjacentHTML("beforeend", tokenObj);
      }

      numberElement.clear();
      expiryElement.clear();
      cvcElement.clear();

      form.removeEventListener("submit", sendForm);
      form.submit();
    });
  }); 
};

window.addEventListener("turbo:load", pay);
window.addEventListener("turbo:render", pay);