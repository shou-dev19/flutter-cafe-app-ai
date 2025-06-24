describe('カート機能の確認', () => {
  beforeEach(() => {
    // GitHub PagesのURLを環境変数から取得するか、直接指定
    const baseUrl = Cypress.env('BASE_URL') || 'https://shou-dev19.github.io/flutter-cafe-app-ai/';
    cy.visit(baseUrl);
  });

  it('カート機能の操作シナリオを実行する', () => {
    // フィルターボタンの"すべて"をクリック
    cy.contains('すべて').click();
    cy.wait(500);

    // ブレンドコーヒーをカートに追加
    // 商品名や追加ボタンのセレクターを特定する必要がある
    // 例: cy.contains('ブレンドコーヒー').parent().find('button.add-to-cart').click();
    // ここでは、商品名を含む要素の親要素から追加ボタンを探すと仮定
    cy.contains('ブレンドコーヒー').parentsUntil('[data-testid^="menu-item-"]').find('button').contains('追加').click();
    cy.wait(500);

    // ブレンドコーヒーをカートから削除
    // カート内の商品や削除ボタンのセレクターを特定する必要がある
    // 例: cy.get('[data-testid="cart-item-ブレンドコーヒー"]').find('button.remove-from-cart').click();
    cy.contains('カートを見る').click();
    cy.wait(500);
    cy.contains('ブレンドコーヒー').parentsUntil('[data-testid^="cart-item-"]').find('button').contains('削除').click();
    cy.wait(500);

    // ブレンドコーヒーをカートに追加
    cy.contains('メニューに戻る').click();
    cy.wait(500);
    cy.contains('ブレンドコーヒー').parentsUntil('[data-testid^="menu-item-"]').find('button').contains('追加').click();
    cy.wait(500);

    // クリームパスタをカートに追加
    cy.contains('クリームパスタ').parentsUntil('[data-testid^="menu-item-"]').find('button').contains('追加').click();
    cy.wait(500);

    // タマゴサンドをカートに追加
    cy.contains('タマゴサンド').parentsUntil('[data-testid^="menu-item-"]').find('button').contains('追加').click();
    cy.wait(500);

    // ブレンドコーヒーをカートに追加
    cy.contains('ブレンドコーヒー').parentsUntil('[data-testid^="menu-item-"]').find('button').contains('追加').click();
    cy.wait(500);

    // クリームパスタをカートから削除
    cy.contains('カートを見る').click();
    cy.wait(500);
    // 複数のクリームパスタがある場合、最初のものを削除すると仮定
    cy.contains('クリームパスタ').first().parentsUntil('[data-testid^="cart-item-"]').find('button').contains('削除').click();
    cy.wait(500);

    // 注文を確定する
    // 注文確定ボタンのセレクターを特定する必要がある
    // 例: cy.get('button.confirm-order').click();
    cy.contains('注文を確定する').click();
    cy.wait(1000); // 注文処理の待機

    // 注文完了メッセージの確認など (任意)
    // cy.contains('ご注文ありがとうございました').should('be.visible');
  });
});
