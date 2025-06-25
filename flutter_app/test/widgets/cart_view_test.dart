import 'package:flutter/material.dart';
import 'package:flutter_app/models/cart_item.dart';
import 'package:flutter_app/models/menu_item.dart' as menu_model;
import 'package:flutter_app/providers/cart_provider.dart';
import 'package:flutter_app/widgets/cart_view.dart';
import 'package:flutter_app/widgets/cart_item_card.dart'; // Import CartItemCard
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/domain/usecases/place_order_use_case.dart';
import 'package:flutter_app/models/cart.dart';
import 'package:flutter_app/data/menu_data.dart'; // Import mockMenuItems for image URLs

// Mock PlaceOrderUseCase for testing
class MockPlaceOrderUseCase implements PlaceOrderUseCase {
  @override
  Future<void> execute(Cart cart) async {
    await Future.delayed(const Duration(milliseconds: 50));
  }
}

// A mock CartNotifier for testing purposes
class MockCartNotifier extends CartNotifier {
  MockCartNotifier(PlaceOrderUseCase placeOrderUseCase) : super(placeOrderUseCase);
  @override
  Future<void> placeOrder() async {
    await Future.delayed(const Duration(milliseconds: 100));
    state = state.clearCart();
  }
}

void main() {
  // Helper function to get a valid image URL from mock data or a default
  String getImageUrlForItem(String itemId) {
    try {
      return mockMenuItems.firstWhere((item) => item.id == itemId).imageUrl;
    } catch (e) {
      return 'assets/menus/espresso.png'; // Default fallback image
    }
  }

  group('CartView', () {
    testWidgets('does not display when cart is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: CartView()),
          ),
        ),
      );
      expect(find.byType(SizedBox), findsOneWidget); // CartView returns SizedBox.shrink()
      expect(find.text('カート'), findsNothing);
    });

    testWidgets('displays cart items, total price, and order button when cart is not empty', (WidgetTester tester) async {
      final container = ProviderContainer();
      final notifier = container.read(cartProvider.notifier);
      final item1 = menu_model.MenuItem(id: '1', name: 'Coffee', price: 250, description: '', imageUrl: getImageUrlForItem('1'), category: 'TestCategory');
      final item2 = menu_model.MenuItem(id: '2', name: 'Tea', price: 200, description: '', imageUrl: getImageUrlForItem('2'), category: 'TestCategory');
      notifier.addItem(item1);
      notifier.addItem(item2);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(body: CartView()),
          ),
        ),
      );

      expect(find.text('カート'), findsOneWidget);
      expect(find.byType(CartItemCard), findsNWidgets(2));
      expect(find.text('Coffee'), findsOneWidget);
      expect(find.text('¥250'), findsOneWidget);
      expect(find.text('1'), findsNWidgets(2)); // Quantity for each item
      expect(find.text('Tea'), findsOneWidget);
      expect(find.text('¥200'), findsOneWidget);
      expect(find.text('合計: ¥450'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, '注文確定'), findsOneWidget);
    });

    testWidgets('tapping + and - buttons in CartItemCard within CartView updates quantity and total', (WidgetTester tester) async {
      final container = ProviderContainer();
      final notifier = container.read(cartProvider.notifier);
      final item1 = menu_model.MenuItem(id: '1', name: 'Coffee', price: 250, description: '', imageUrl: getImageUrlForItem('1'), category: 'TestCategory');
      notifier.addItem(item1);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(body: CartView()),
          ),
        ),
      );

      expect(find.text('Coffee'), findsOneWidget);
      expect(find.text('1'), findsOneWidget); // Initial quantity
      expect(find.text('合計: ¥250'), findsOneWidget);

      // Find the CartItemCard for Coffee
      final coffeeCardFinder = find.widgetWithText(CartItemCard, 'Coffee');
      expect(coffeeCardFinder, findsOneWidget);

      // Tap + button
      await tester.tap(find.descendant(of: coffeeCardFinder, matching: find.byIcon(Icons.add_circle_outline)));
      await tester.pumpAndSettle();
      expect(find.text('2'), findsOneWidget); // Quantity updated
      expect(find.text('合計: ¥500'), findsOneWidget); // Total updated

      // Tap - button
      await tester.tap(find.descendant(of: coffeeCardFinder, matching: find.byIcon(Icons.remove_circle_outline)));
      await tester.pumpAndSettle();
      expect(find.text('1'), findsOneWidget); // Quantity updated
      expect(find.text('合計: ¥250'), findsOneWidget); // Total updated

      // Tap - button again to remove item
      await tester.tap(find.descendant(of: coffeeCardFinder, matching: find.byIcon(Icons.remove_circle_outline)));
      await tester.pumpAndSettle();

      expect(find.text('Coffee'), findsNothing); // Item removed
      expect(find.text('カート'), findsNothing); // Cart becomes empty
      expect(find.byType(SizedBox), findsOneWidget); // CartView shows SizedBox.shrink
    });

    testWidgets('tapping order button clears cart and shows SnackBar', (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          cartProvider.overrideWith((ref) => MockCartNotifier(MockPlaceOrderUseCase())),
        ],
      );
      final notifier = container.read(cartProvider.notifier);
      final item1 = menu_model.MenuItem(id: '1', name: 'Coffee', price: 250, description: '', imageUrl: getImageUrlForItem('1'), category: 'TestCategory');
      notifier.addItem(item1);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(body: CartView()),
          ),
        ),
      );

      expect(find.text('Coffee'), findsOneWidget);
      await tester.tap(find.widgetWithText(ElevatedButton, '注文確定'));
      await tester.pump();
      await tester.pumpAndSettle(const Duration(milliseconds: 150));

      expect(find.text('注文が完了しました！'), findsOneWidget);
      expect(find.text('Coffee'), findsNothing);
      expect(find.text('カート'), findsNothing);
      expect(find.byType(SizedBox), findsOneWidget);
    });
  });
}
