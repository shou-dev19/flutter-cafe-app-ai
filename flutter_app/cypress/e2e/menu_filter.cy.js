describe('メニューのカテゴリーフィルター機能の確認', () => {
  beforeEach(() => {
    // GitHub PagesのURLを環境変数から取得するか、直接指定
    const baseUrl = Cypress.env('BASE_URL') || 'https://shou-dev19.github.io/flutter-cafe-app-ai/';
    cy.visit(baseUrl);
  });

  it('画面に表示されているフィルターボタンを左から順番にクリックする', () => {
    // フィルターボタンのセレクターを仮定 (例: data-testid="filter-button-<category>")
    // 実際のボタンのテキストや属性に応じて調整が必要
    const filterCategories = ['すべて', 'コーヒー', '紅茶', 'その他']; // 仮のカテゴリー名

    filterCategories.forEach(category => {
      // ボタンのテキストや属性に基づいてセレクターを調整
      // 例: cy.contains('button', category).click();
      // 例: cy.get(`[data-testid="filter-button-${category.toLowerCase()}"]`).click();
      // ここでは、ボタンが特定のテキストを持つと仮定
      cy.contains(category).click();
      cy.wait(500); // アニメーションや状態変更のための待機
    });
  });
});
