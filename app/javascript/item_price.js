window.addEventListener('turbo:load', () => {
  // 販売価格(priceInput.value)の入力欄の要素を取得し、priceInput変数に格納
  const priceInput = document.getElementById("item-price");

  // 【追加】要素が存在しない場合は、ここで処理を終了する（ガード句）
  if (!priceInput) return;

  // 販売価格(priceInput.value)入力欄に値が入力されるたびに実行されるイベントリスナーを追加
  priceInput.addEventListener("input", () => {
    const inputValue = priceInput.value; // 入力された販売価格(priceInput.value)の値を取得し、inputValue変数に格納される。
    const addTaxDom = document.getElementById("add-tax-price"); // 販売手数料(tax)表示欄の要素を取得し、addTaxDom変数に格納される。
    const profitDom = document.getElementById("profit"); // 利益(profit)表示欄の要素を取得し、profitDom変数に格納される。

    // 販売手数料[tax（10%）]を計算。Math.floor関数で小数点以下を切り捨て。
    const tax = Math.floor(inputValue * 0.1); // 販売手数料[(tax)10%]が計算されてtax変数に格納される。
    addTaxDom.innerHTML = tax; // 販売手数料(tax)を表示欄に反映

    // 利益(profit)を計算。
    const profit = inputValue - tax; // 利益 = 販売価格 - 販売手数料  [利益(profit)が計算されてprofit変数に格納される。]
    profitDom.innerHTML = profit; // 利益(profit)を表示欄に反映
  })
});

// windowオブジェクトとは、ブラウザのウィンドウを表すオブジェクトであり、グローバルなコンテキストを提供する。
  // windowオブジェクトのaddEventListenerメソッドを使って、特定のイベントが発生したときに関数を実行するようにしている。
  // windowオブジェクトは上位のオブジェクトであり、ブラウザ環境で利用できる様々なプロパティやメソッドを持っている。

  // addEventListenerメソッドとは、指定したイベントが発生したときに特定の関数を実行するためのメソッドである。
  // addEventListenerメソッドを使って、inputイベントが発生したときに実行される関数を登録している。
  //HTMLの読み込みが完了したタイミングで関数を実行するようにしている。

// inputイベントとは、ユーザーが入力欄に値を入力したときに発生するイベントである。
  // inputイベントリスナーを追加して、ユーザーが入力欄に値を入力するたびに関数が実行されるようにしている。

// turbo:loadイベントとは、TurboライブラリがHTMLの読み込みを完了したときに発生するイベントである。
  // turbo:loadイベントを使うことで、Turboを使用している場合でも、HTMLの読み込みが完了したタイミングで関数を実行することができる。
  // これにより、ページの動的な読み込みが行われても、正しくイベントリスナーが設定される。

// constとは、再代入が禁止された変数を宣言するためのキーワードである。
  // constを使って宣言された変数は、再代入が禁止されているため、値が変更されることはない。
  // 例えば、const priceInput = document.getElementById("item-price");と宣言されたpriceInput変数には、再代入ができない。
  // ただし、オブジェクトや配列の場合は、そのプロパティや要素の変更は可能である。

// getElementByIdメソッドとは、HTMLドキュメント内の特定のIDを持つ要素を取得するためのメソッドである。
  // getElementById("item-price")は、販売価格の入力欄の要素を取得している。
  // getElementById("add-tax-price")は、販売手数料の表示欄の要素を取得している。
  // getElementById("profit")は、利益の表示欄の要素を取得している。
  
// innerHTMLプロパティとは、HTML要素の内容を取得または設定するためのプロパティである。
  // innerHTMLプロパティを使って、計算結果をそれぞれの表示欄に反映させている。
  // 例えば、addTaxDom.innerHTML = tax;とすることで、販売手数料の表示欄に計算された手数料が表示される。

// Math.floor関数とは、引数として与えられた数値の小数点以下を切り捨てて、整数部分だけを返す関数である。
  // 例えば、Math.floor(4.7)は4を返す。