import 'package:flutter/material.dart';
import 'package:flutter_app/models/cart_item.dart';
import 'package:flutter_app/providers/cart_provider.dart';
import 'package:flutter_app/widgets/cart_item_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/models/menu_item.dart';
void main() {
  testWidgets('CartItemCard displays item details and remove button', (WidgetTester tester) async {
    final cartItem = CartItem(id: '1', name: 'Coffee', price: 2.50, quantity: 2);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: CartItemCard(cartItem: cartItem),
          ),
        ),
      ),
    );

    expect(find.text('Coffee'), findsOneWidget);
    expect(find.text('\$2.50 x 2'), findsOneWidget);
    expect(find.byIcon(Icons.remove_shopping_cart), findsOneWidget);
  });

  testWidgets('CartItemCard calls removeItem when remove button is tapped', (WidgetTester tester) async {
    final cartItem = CartItem(id: '1', name: 'Coffee', price: 2.50, quantity: 1);
    final container = ProviderContainer();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            body: CartItemCard(cartItem: cartItem),
          ),
        ),
      ),
    );

    // Verify initial cart state (optional, but good for clarity)
    expect(container.read(cartProvider).items.length, 0);

    // Add item to cart directly for testing removal
    final menuItemForCart = MenuItem(id: cartItem.id, name: cartItem.name, price: cartItem.price, description: 'Test Description', imageUrl: 'test_url', category: 'TestCategory');
    container.read(cartProvider.notifier).addItem(menuItemForCart);
    expect(container.read(cartProvider).items.length, 1);

    await tester.tap(find.byIcon(Icons.remove_shopping_cart));
    await tester.pump();

    expect(container.read(cartProvider).items.isEmpty, true);
  });
}
