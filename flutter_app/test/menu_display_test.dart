

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      await tester.pumpWidget(const ProviderScope(child: MyApp()));

      expect(find.text('メニュー'), findsOneWidget);

      // Verify that all mock menu items are displayed
      for (var item in mockMenuItems) {
        // Scroll until the item's name is visible
        // It's important to ensure the GridView itself is used as the scrollable element
        // or a common ancestor Scrollable.
        final gridViewWidgetFinder = find.byType(GridView);
        expect(gridViewWidgetFinder, findsOneWidget, reason: "GridView not found");

        // Find the actual Scrollable widget used by the GridView.
        // GridView itself is a ScrollView, which builds a Scrollable widget internally.
        final scrollableFinder = find.descendant(
          of: gridViewWidgetFinder,
          matching: find.byType(Scrollable),
        );
        expect(scrollableFinder, findsOneWidget, reason: "Scrollable widget within GridView not found");

        await tester.scrollUntilVisible(
          find.text(item.name),
          50.0, // Amount to scroll by in each step (logical pixels)
          scrollable: scrollableFinder,
          maxScrolls: 20, // Limit the number of scrolls to prevent infinite loops
        );
        await tester.pumpAndSettle(); // Settle animations after scrolling

        expect(find.text(item.name), findsOneWidget, reason: "Could not find ${item.name} even after scrolling");
        // We cannot reliably check for price text directly as multiple items might have the same price.
        // Instead, we rely on the MenuCard widget displaying the correct price within its context.
      }

      // Verify that the correct number of MenuCard widgets are rendered
      expect(find.byType(MenuCard), findsNWidgets(mockMenuItems.length));
    });

    testWidgets('Adding item to cart shows SnackBar', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));

      // Tap the first "カートへ追加" button
      await tester.tap(find.widgetWithText(ElevatedButton, 'カートへ追加').first);
      await tester.pumpAndSettle(); // Ensure SnackBar appears and settles

      // Verify SnackBar is shown
      expect(find.text('${mockMenuItems.first.name}をカートに追加しました'), findsOneWidget);

      await tester.pump(const Duration(seconds: 1)); // Wait for SnackBar's duration to pass
      await tester.pumpAndSettle(); // Wait for dismissal animation to complete
      expect(find.text('${mockMenuItems.first.name}をカートに追加しました'), findsNothing);
    });
  });
}

