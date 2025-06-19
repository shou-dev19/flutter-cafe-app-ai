

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/models/menu_item.dart';
import 'package:flutter_app/widgets/menu_card.dart';
import 'package:flutter_app/data/menu_data.dart';

void main() {
  group('MenuCard', () {
    testWidgets('MenuCard displays item information correctly', (WidgetTester tester) async {
      final testItem = MenuItem(
        id: 'test1',
        name: 'Test Coffee',
        description: 'A delicious test coffee.',
        price: 500,
        imageUrl: 'https://via.placeholder.com/150',
      );

      bool buttonPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MenuCard(
              item: testItem,
              onAddToCart: () {
                buttonPressed = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Test Coffee'), findsOneWidget);
      expect(find.text('A delicious test coffee.'), findsOneWidget);
      expect(find.text('¥500'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'カートへ追加'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);

      await tester.tap(find.widgetWithText(ElevatedButton, 'カートへ追加'));
      await tester.pumpAndSettle();
      expect(buttonPressed, isTrue);
    });
  });

  group('MenuScreen', () {
    testWidgets('MenuScreen displays all menu items', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.text('メニュー'), findsOneWidget);

      // Verify that all mock menu items are displayed
      for (var item in mockMenuItems) {
        expect(find.text(item.name), findsOneWidget);
        // We cannot reliably check for price text directly as multiple items might have the same price.
        // Instead, we rely on the MenuCard widget displaying the correct price within its context.
      }

      // Verify that the correct number of MenuCard widgets are rendered
      expect(find.byType(MenuCard), findsNWidgets(mockMenuItems.length));
    });

    testWidgets('Adding item to cart shows SnackBar', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Tap the first "カートへ追加" button
      await tester.tap(find.widgetWithText(ElevatedButton, 'カートへ追加').first);
      await tester.pump(); // Pump to trigger the SnackBar animation

      // Verify SnackBar is shown
      expect(find.text('${mockMenuItems.first.name}をカートに追加しました'), findsOneWidget);

      await tester.pump(const Duration(seconds: 3)); // Wait for SnackBar to disappear
      await tester.pumpAndSettle();
      expect(find.text('${mockMenuItems.first.name}をカートに追加しました'), findsNothing);
    });
  });
}

