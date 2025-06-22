
import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/models/menu_item.dart';
import 'package:flutter_app/widgets/menu_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/lib/data/menu_data.dart'; // Import mockMenuItems

void main() {
  testWidgets('MenuScreen filter functionality test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Verify initial state (all items shown)
    // Count MenuCard widgets
    int initialItemCount = mockMenuItems.length;
    expect(find.byType(MenuCard), findsNWidgets(initialItemCount));
    expect(find.text('ブレンドコーヒー'), findsOneWidget);
    expect(find.text('紅茶'), findsOneWidget);
    expect(find.text('クリームパスタ'), findsOneWidget);
    expect(find.text('タマゴサンド'), findsOneWidget);


    // Tap on 'コーヒー' filter
    await tester.tap(find.text('コーヒー'));
    await tester.pumpAndSettle(); // Rebuild the widget tree

    // Verify only coffee items are shown
    int coffeeItemCount = mockMenuItems.where((item) => item.category == 'コーヒー').length;
    expect(find.byType(MenuCard), findsNWidgets(coffeeItemCount));
    expect(find.text('ブレンドコーヒー'), findsOneWidget);
    expect(find.text('カフェラテ'), findsOneWidget);
    expect(find.text('紅茶'), findsNothing); // Should not be visible
    expect(find.text('クリームパスタ'), findsNothing); // Should not be visible
    expect(find.text('タマゴサンド'), findsNothing); // Should not be visible


    // Tap on 'お茶' filter
    await tester.tap(find.text('お茶'));
    await tester.pumpAndSettle();

    // Verify only tea items are shown
    int teaItemCount = mockMenuItems.where((item) => item.category == 'お茶').length;
    expect(find.byType(MenuCard), findsNWidgets(teaItemCount));
    expect(find.text('紅茶'), findsOneWidget);
    expect(find.text('ブレンドコーヒー'), findsNothing); // Should not be visible

    // Tap on 'パスタ' filter
    await tester.tap(find.text('パスタ'));
    await tester.pumpAndSettle();

    // Verify only pasta items are shown
    int pastaItemCount = mockMenuItems.where((item) => item.category == 'パスタ').length;
    expect(find.byType(MenuCard), findsNWidgets(pastaItemCount));
    expect(find.text('クリームパスタ'), findsOneWidget);
    expect(find.text('ブレンドコーヒー'), findsNothing); // Should not be visible

    // Tap on 'サンドイッチ' filter
    await tester.tap(find.text('サンドイッチ'));
    await tester.pumpAndSettle();

    // Verify only sandwich items are shown
    int sandwichItemCount = mockMenuItems.where((item) => item.category == 'サンドイッチ').length;
    expect(find.byType(MenuCard), findsNWidgets(sandwichItemCount));
    expect(find.text('タマゴサンド'), findsOneWidget);
    expect(find.text('ブレンドコーヒー'), findsNothing); // Should not be visible

    // Tap on 'すべて' filter
    await tester.tap(find.text('すべて'));
    await tester.pumpAndSettle();

    // Verify all items are shown again
    expect(find.byType(MenuCard), findsNWidgets(initialItemCount));
    expect(find.text('ブレンドコーヒー'), findsOneWidget);
    expect(find.text('紅茶'), findsOneWidget);
    expect(find.text('クリームパスタ'), findsOneWidget);
    expect(find.text('タマゴサンド'), findsOneWidget);
  });
}
