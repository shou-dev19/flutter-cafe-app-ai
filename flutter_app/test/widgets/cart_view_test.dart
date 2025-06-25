import 'package:flutter/material.dart';
import 'package:flutter_app/models/menu_item.dart' as menu_model;
import 'package:flutter_app/providers/cart_provider.dart';
import 'package:flutter_app/widgets/cart_view.dart';
import 'package:flutter_app/widgets/cart_item_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/domain/usecases/place_order_use_case.dart';
import 'package:flutter_app/models/cart.dart';

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
  // Helper function to create a testable widget with CartView
  Widget createTestableWidget(Widget child, ProviderContainer container) {
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        home: Scaffold(
          body: Stack( // CartView is now a Positioned widget, so it needs a Stack
            children: [child],
          ),
        ),
      ),
    );
  }

  final coffeeItem = menu_model.MenuItem(id: '1', name: 'Coffee', price: 2.50, description: 'Tasty coffee', imageUrl: 'coffee.png', category: 'Drinks');
  final teaItem = menu_model.MenuItem(id: '2', name: 'Tea', price: 2.00, description: 'Refreshing tea', imageUrl: 'tea.png', category: 'Drinks');


  group('CartView', () {
    testWidgets('does not display when cart is empty', (WidgetTester tester) async {
      final container = ProviderContainer();
      await tester.pumpWidget(createTestableWidget(const CartView(), container));

      // CartView returns SizedBox.shrink() when empty
      expect(find.byType(Positioned), findsNothing); // The Positioned widget that wraps CartView when not empty
      expect(find.textContaining('カート'), findsNothing);
    });

    testWidgets('displays collapsed cart bar when cart is not empty and not expanded', (WidgetTester tester) async {
      final container = ProviderContainer();
      final notifier = container.read(cartProvider.notifier);
      notifier.addItem(coffeeItem);

      await tester.pumpWidget(createTestableWidget(const CartView(), container));
      await tester.pumpAndSettle(); // Allow animations/state to settle

      expect(find.textContaining('カート (1種類)'), findsOneWidget);
      expect(find.textContaining('合計: \$2.50'), findsOneWidget); // Total in collapsed bar
      expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget); // Expand icon

      // Items and order button should not be visible when collapsed
      expect(find.text('Coffee'), findsNothing);
      expect(find.widgetWithText(ElevatedButton, '注文確定'), findsNothing);
    });

    testWidgets('expands and collapses cart on tap', (WidgetTester tester) async {
      final container = ProviderContainer();
      final notifier = container.read(cartProvider.notifier);
      notifier.addItem(coffeeItem);
      notifier.addItem(teaItem);

      await tester.pumpWidget(createTestableWidget(const CartView(), container));
      await tester.pumpAndSettle();

      // Initial state: collapsed
      expect(find.textContaining('カート (2種類)'), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
      expect(find.text('Coffee'), findsNothing);
      expect(find.text('Tea'), findsNothing);
      expect(find.widgetWithText(ElevatedButton, '注文確定'), findsNothing);

      // Tap to expand
      await tester.tap(find.byType(GestureDetector).first); // Tap the header bar
      await tester.pumpAndSettle(); // Wait for animation

      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget); // Collapse icon
      expect(find.text('Coffee'), findsOneWidget); // Item name from CartItemCard
      expect(find.text('Tea'), findsOneWidget);   // Item name from CartItemCard
      expect(find.textContaining('合計: \$4.50'), findsNWidgets(2)); // One in header, one in expanded view
      expect(find.widgetWithText(ElevatedButton, '注文確定'), findsOneWidget);

      // Tap to collapse
      await tester.tap(find.byType(GestureDetector).first); // Tap the header bar again
      await tester.pumpAndSettle(); // Wait for animation

      expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget); // Expand icon
      expect(find.text('Coffee'), findsNothing);
      expect(find.text('Tea'), findsNothing);
      expect(find.widgetWithText(ElevatedButton, '注文確定'), findsNothing);
    });

    testWidgets('tapping remove button in CartItemCard within CartView removes item and updates UI', (WidgetTester tester) async {
      final container = ProviderContainer();
      final notifier = container.read(cartProvider.notifier);
      notifier.addItem(coffeeItem);
      notifier.addItem(teaItem);

      await tester.pumpWidget(createTestableWidget(const CartView(), container));
      await tester.pumpAndSettle();

      // Expand the cart to make items visible
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();

      expect(find.text('Coffee'), findsOneWidget);
      expect(find.text('Tea'), findsOneWidget);
      expect(find.textContaining('カート (2種類)'), findsOneWidget);

      // Find the remove button for 'Coffee' (assuming CartItemCard has an identifiable remove button)
      // This might need a more specific finder if Icons.remove_shopping_cart is not unique enough
      // For simplicity, we assume the first one found is for the first item if order is predictable.
      // A better way would be to find within the specific CartItemCard.
      await tester.tap(find.descendant(of: find.widgetWithText(CartItemCard, 'Coffee'), matching: find.byIcon(Icons.remove_shopping_cart)));
      await tester.pumpAndSettle();

      // Coffee should be removed, Tea remains, cart count updates
      expect(find.text('Coffee'), findsNothing);
      expect(find.text('Tea'), findsOneWidget);
      expect(find.textContaining('カート (1種類)'), findsOneWidget); // Header updates
      expect(find.textContaining('合計: \$2.00'), findsNWidgets(2)); // Header and expanded view update

      // Remove the last item (Tea)
      await tester.tap(find.descendant(of: find.widgetWithText(CartItemCard, 'Tea'), matching: find.byIcon(Icons.remove_shopping_cart)));
      await tester.pumpAndSettle();

      // CartView should now be empty (SizedBox.shrink)
      expect(find.byType(Material), findsNothing); // The main Material widget of CartView should be gone
      expect(find.textContaining('カート'), findsNothing);
    });

    testWidgets('tapping order button clears cart, shows SnackBar, and collapses/hides cart', (WidgetTester tester) async {
      final mockPlaceOrderUseCase = MockPlaceOrderUseCase();
      final container = ProviderContainer(
        overrides: [
          cartProvider.overrideWith((ref) => MockCartNotifier(mockPlaceOrderUseCase)),
        ],
      );
      final notifier = container.read(cartProvider.notifier);
      notifier.addItem(coffeeItem);

      await tester.pumpWidget(createTestableWidget(const CartView(), container));
      await tester.pumpAndSettle();

      // Expand the cart
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();

      expect(find.text('Coffee'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, '注文確定'), findsOneWidget);

      // Tap order button
      await tester.tap(find.widgetWithText(ElevatedButton, '注文確定'));
      await tester.pump(); // Start the order process (animations, SnackBar)
      // Wait for SnackBar, cart clear, and animations
      await tester.pumpAndSettle(const Duration(milliseconds: 200)); // Mock delay + animation time

      // Check for SnackBar
      expect(find.text('注文が完了しました！'), findsOneWidget);

      // CartView should now be empty (SizedBox.shrink) because cart is cleared
      expect(find.byType(Material), findsNothing);
      expect(find.textContaining('カート'), findsNothing);
      expect(find.text('Coffee'), findsNothing);
    });
  });
}
