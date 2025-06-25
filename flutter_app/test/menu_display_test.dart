

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/models/menu_item.dart';
import 'package:flutter_app/widgets/menu_card.dart';
import 'package:flutter_app/data/menu_data.dart';
import 'package:flutter_app/providers/cart_provider.dart'; // Import CartProvider

void main() {
  group('MenuCard', () {
    final testItem = MenuItem(
      id: 'test1',
      name: 'Test Coffee',
      description: 'A delicious test coffee.',
      price: 500,
      imageUrl: 'assets/menus/espresso.png', // Use a valid asset
      category: 'Test Category',
    );

    testWidgets('MenuCard displays item information and quantity controls', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope( // Wrap with ProviderScope
          child: MaterialApp(
            home: Scaffold(
              body: MenuCard(
                item: testItem,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Test Coffee'), findsOneWidget);
      expect(find.text('A delicious test coffee.'), findsOneWidget);
      expect(find.text('¥500'), findsOneWidget);
      expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);
      expect(find.byIcon(Icons.remove_circle_outline), findsOneWidget);
      expect(find.text('0'), findsOneWidget); // Initial quantity
      // expect(find.byType(Image), findsOneWidget); // Image is more complex to test here due to asset loading
    });

    testWidgets('Increment and decrement quantity in MenuCard', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: MenuCard(
                item: testItem,
              ),
            ),
          ),
        ),
      );

      // Increment
      await tester.tap(find.byIcon(Icons.add_circle_outline));
      await tester.pump();
      expect(find.text('1'), findsOneWidget);

      // Increment again
      await tester.tap(find.byIcon(Icons.add_circle_outline));
      await tester.pump();
      expect(find.text('2'), findsOneWidget);

      // Decrement
      await tester.tap(find.byIcon(Icons.remove_circle_outline));
      await tester.pump();
      expect(find.text('1'), findsOneWidget);

      // Decrement to zero
      await tester.tap(find.byIcon(Icons.remove_circle_outline));
      await tester.pump();
      expect(find.text('0'), findsOneWidget);

      // Decrementing at zero should not change quantity (item removed from cart, but card shows 0)
      await tester.tap(find.byIcon(Icons.remove_circle_outline));
      await tester.pump();
      expect(find.text('0'), findsOneWidget);
    });
  });

  group('MenuScreen', () {
    testWidgets('MenuScreen displays all menu items and interacts with cart', (WidgetTester tester) async {
      const double screenWidth = 800;
      const double screenHeight = 2300;
      tester.binding.window.physicalSizeTestValue = const Size(screenWidth, screenHeight);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      addTearDown(() {
        tester.binding.window.clearPhysicalSizeTestValue();
        tester.binding.window.clearDevicePixelRatioTestValue();
      });

      await tester.pumpWidget(const ProviderScope(child: MyApp()));
      await tester.pumpAndSettle();


      expect(find.text('The Cozy Corner'), findsOneWidget);

      // Verify that all mock menu items are displayed with quantity controls
      for (var item in mockMenuItems) {
        final gridViewWidgetFinder = find.byType(GridView);
        expect(gridViewWidgetFinder, findsOneWidget);
        final scrollableFinder = find.descendant(
          of: gridViewWidgetFinder,
          matching: find.byType(Scrollable),
        );
        expect(scrollableFinder, findsOneWidget);

        // Scroll to the MenuCard for the current item
        // We find the MenuCard by looking for a descendant Text widget with the item's name
        // within a MenuCard widget.
        final menuCardFinder = find.widgetWithText(MenuCard, item.name);
        await tester.scrollUntilVisible(
          menuCardFinder,
          50.0,
          scrollable: scrollableFinder,
          maxScrolls: 50,
        );
        await tester.pumpAndSettle();

        expect(menuCardFinder, findsOneWidget, reason: "Could not find MenuCard for ${item.name}");

        // Check for item details within its card
        final itemCardFinder = find.ancestor(of: find.text(item.name), matching: find.byType(MenuCard));
        expect(find.descendant(of: itemCardFinder, matching: find.text('¥${item.price.toStringAsFixed(0)}')), findsOneWidget);
        expect(find.descendant(of: itemCardFinder, matching: find.byIcon(Icons.add_circle_outline)), findsOneWidget);
        expect(find.descendant(of: itemCardFinder, matching: find.byIcon(Icons.remove_circle_outline)), findsOneWidget);
        expect(find.descendant(of: itemCardFinder, matching: find.text('0')), findsOneWidget); // Initial quantity
      }

      expect(find.byType(MenuCard), findsNWidgets(mockMenuItems.length));

      // Test adding an item to cart from MenuScreen
      final firstItem = mockMenuItems.first;
      final firstItemCardFinder = find.widgetWithText(MenuCard, firstItem.name);

      // Scroll to the first item if not visible
      final gridViewWidgetFinder = find.byType(GridView);
      final scrollableFinder = find.descendant(of: gridViewWidgetFinder, matching: find.byType(Scrollable));
      await tester.scrollUntilVisible(firstItemCardFinder, 50.0, scrollable: scrollableFinder, maxScrolls: 20);
      await tester.pumpAndSettle();


      final addIconFinder = find.descendant(
        of: firstItemCardFinder,
        matching: find.byIcon(Icons.add_circle_outline),
      );
      expect(addIconFinder, findsOneWidget);
      await tester.tap(addIconFinder);
      await tester.pumpAndSettle();

      // Verify SnackBar
      expect(find.text('${firstItem.name}をカートに追加しました'), findsOneWidget);
      // Verify quantity updated on the card
      expect(find.descendant(of: firstItemCardFinder, matching: find.text('1')), findsOneWidget);

      await tester.pump(const Duration(seconds: 3)); // Wait for SnackBar to disappear
      await tester.pumpAndSettle();
      expect(find.text('${firstItem.name}をカートに追加しました'), findsNothing);

      // Test removing an item from cart from MenuScreen
      final removeIconFinder = find.descendant(
        of: firstItemCardFinder,
        matching: find.byIcon(Icons.remove_circle_outline),
      );
      expect(removeIconFinder, findsOneWidget);
      await tester.tap(removeIconFinder);
      await tester.pumpAndSettle();

      // Verify SnackBar for removal
      expect(find.text('${firstItem.name}をカートから削除しました'), findsOneWidget);
      // Verify quantity updated on the card
      expect(find.descendant(of: firstItemCardFinder, matching: find.text('0')), findsOneWidget);

      await tester.pump(const Duration(seconds: 3)); // Wait for SnackBar to disappear
      await tester.pumpAndSettle();
      expect(find.text('${firstItem.name}をカートから削除しました'), findsNothing);

    });
  });
}

