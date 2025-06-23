import 'package:flutter/material.dart';
import 'package:flutter_app/models/cart_item.dart';
import 'package:flutter_app/models/menu_item.dart' as menu_model;
import 'package:flutter_app/providers/cart_provider.dart';
import 'package:flutter_app/widgets/cart_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/domain/usecases/place_order_use_case.dart';
import 'package:flutter_app/models/cart.dart';

// Mock PlaceOrderUseCase for testing
class MockPlaceOrderUseCase implements PlaceOrderUseCase {
  @override
  Future<void> execute(Cart cart) async {
    // Simulate a network request or any other logic
    await Future.delayed(const Duration(milliseconds: 50));
  }
}

// A mock CartNotifier for testing purposes
class MockCartNotifier extends CartNotifier {
  MockCartNotifier(PlaceOrderUseCase placeOrderUseCase) : super(placeOrderUseCase);
  @override
  Future<void> placeOrder() async {
    // Simulate a network request
    await Future.delayed(const Duration(milliseconds: 100)); // Shorter delay for tests
    state = state.clearCart(); // Clear cart as in the original
  }
}

void main() {
  group('CartView', () {
    testWidgets('does not display when cart is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: CartView()),
          ),
        ),
      );

      expect(find.byType(Container), findsNothing); // CartView returns SizedBox.shrink()
      expect(find.text('カート'), findsNothing);
    });

    testWidgets('displays cart items, total price, and order button when cart is not empty', (WidgetTester tester) async {
      final container = ProviderContainer();
      // Pre-populate the cart
      final notifier = container.read(cartProvider.notifier);
      notifier.addItem(menu_model.MenuItem(id: '1', name: 'Coffee', price: 2.50, description: '', imageUrl: '', category: 'TestCategory'));
      notifier.addItem(menu_model.MenuItem(id: '2', name: 'Tea', price: 2.00, description: '', imageUrl: '', category: 'TestCategory'));

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(body: CartView()),
          ),
        ),
      );

      expect(find.text('カート'), findsOneWidget);
      expect(find.text('Coffee'), findsOneWidget);
      expect(find.text('\$2.50 x 1'), findsOneWidget);
      expect(find.text('Tea'), findsOneWidget);
      expect(find.text('\$2.00 x 1'), findsOneWidget);
      expect(find.text('合計: \$4.50'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, '注文確定'), findsOneWidget);
    });

    testWidgets('tapping remove button in CartItemCard within CartView removes item', (WidgetTester tester) async {
      final container = ProviderContainer();
      final notifier = container.read(cartProvider.notifier);
      notifier.addItem(menu_model.MenuItem(id: '1', name: 'Coffee', price: 2.50, description: '', imageUrl: '', category: 'TestCategory'));

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(body: CartView()),
          ),
        ),
      );

      expect(find.text('Coffee'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.remove_shopping_cart));
      await tester.pumpAndSettle(); // Allow time for state update and rebuild

      // CartView should now be empty (SizedBox.shrink)
      expect(find.text('Coffee'), findsNothing);
      expect(find.text('カート'), findsNothing);
    });

    testWidgets('tapping order button clears cart and shows SnackBar', (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          // Override the cartProvider to use MockCartNotifier for predictable behavior
          cartProvider.overrideWith((ref) => MockCartNotifier(MockPlaceOrderUseCase())),
        ],
      );
      final notifier = container.read(cartProvider.notifier);
      notifier.addItem(menu_model.MenuItem(id: '1', name: 'Coffee', price: 2.50, description: '', imageUrl: '', category: 'TestCategory'));

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
      await tester.pump(); // Start the order process
      // Wait for the SnackBar to appear and the cart to clear
      // The duration of pumpAndSettle should be longer than the mock delay in placeOrder
      await tester.pumpAndSettle(const Duration(milliseconds: 150));

      expect(find.text('注文が完了しました！'), findsOneWidget);
      // CartView should now be empty (SizedBox.shrink)
      expect(find.text('Coffee'), findsNothing);
      expect(find.text('カート'), findsNothing);
    });
  });
}
