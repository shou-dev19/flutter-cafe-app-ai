

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
      expect(find.widgetWithText(ElevatedButton, 'Add'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
      await tester.pumpAndSettle();
      expect(buttonPressed, isTrue);
    });
  });

  group('MenuScreen', () {
    testWidgets('MenuScreen displays all menu items', (WidgetTester tester) async {
      // Set a large enough window size to ensure all items can be rendered by GridView
      // GridView width = 3/4 of screen. If screen width = 800, GridView width = 600 -> 2 columns.
      // Card height = 300 / 0.7 = ~428.6.
      // For 6 items in 2 columns, we need 3 rows. Total height = 3 * 428.6 + 2 * 10 (spacing) = ~1305.
      // Add some padding for safety.
      const double screenWidth = 800;
      const double screenHeight = 1400; // Increased height
      tester.binding.window.physicalSizeTestValue = const Size(screenWidth, screenHeight);
      tester.binding.window.devicePixelRatioTestValue = 1.0; // Ensure logical pixels match physical for simplicity

      await tester.pumpWidget(const ProviderScope(child: MyApp()));

      // Reset window size after test to avoid affecting other tests
      addTearDown(() {
        tester.binding.window.clearPhysicalSizeTestValue();
        tester.binding.window.clearDevicePixelRatioTestValue();
      });

      expect(find.text('The Cozy Corner'), findsOneWidget);

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
          maxScrolls: 50, // Limit the number of scrolls to prevent infinite loops
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
      // Set a reasonable window size for this test too
      const double screenWidth = 800;
      const double screenHeight = 1200; // Ensure enough height for visibility
      tester.binding.window.physicalSizeTestValue = const Size(screenWidth, screenHeight);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      addTearDown(() {
        tester.binding.window.clearPhysicalSizeTestValue();
        tester.binding.window.clearDevicePixelRatioTestValue();
      });
      await tester.pumpWidget(const ProviderScope(child: MyApp()));

      await tester.pumpAndSettle(); // Allow layout to stabilize after pumpWidget

      // Find the first "Add" button
      final addButtonFinder = find.widgetWithText(ElevatedButton, 'Add').first;

      // Find the GridView's Scrollable
      final gridViewWidgetFinder = find.byType(GridView);
      expect(gridViewWidgetFinder, findsOneWidget, reason: "GridView not found for scrolling");
      final scrollableFinder = find.descendant(
        of: gridViewWidgetFinder,
        matching: find.byType(Scrollable),
      );
      expect(scrollableFinder, findsOneWidget, reason: "Scrollable within GridView not found");

      // Scroll until the button is visible
      await tester.scrollUntilVisible(
        addButtonFinder,
        50.0, // Scroll increment
        scrollable: scrollableFinder,
        maxScrolls: 20, // Limit scrolls
      );
      await tester.pumpAndSettle(); // Settle after scrolling

      // Tap the first "Add" button
      await tester.tap(addButtonFinder);
      await tester.pumpAndSettle(); // Ensure SnackBar appears and settles

      // Verify SnackBar is shown
      expect(find.text('${mockMenuItems.first.name}をカートに追加しました'), findsOneWidget);

      await tester.pump(const Duration(seconds: 1)); // Wait for SnackBar's duration to pass
      await tester.pumpAndSettle(); // Wait for dismissal animation to complete
      expect(find.text('${mockMenuItems.first.name}をカートに追加しました'), findsNothing);
    });
  });
}

