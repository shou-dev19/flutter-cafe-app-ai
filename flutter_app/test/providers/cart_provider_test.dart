import 'package:flutter_app/models/cart.dart';
import 'package:flutter_app/models/menu_item.dart';
import 'package:flutter_app/providers/cart_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('CartNotifier', () {
    late ProviderContainer container;
    late CartNotifier cartNotifier;

    setUp(() {
      container = ProviderContainer();
      cartNotifier = container.read(cartProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is an empty cart', () {
      expect(container.read(cartProvider).items, isEmpty);
      expect(container.read(cartProvider).totalPrice, 0.0);
    });

    test('addItem should add a menu item to the cart', () {
      final menuItem = MenuItem(id: '1', name: 'Coffee', description: 'Hot coffee', price: 2.50, imageUrl: '', category: 'TestCategory');
      cartNotifier.addItem(menuItem);

      final cart = container.read(cartProvider);
      expect(cart.items.length, 1);
      expect(cart.items.first.id, '1');
      expect(cart.items.first.name, 'Coffee');
      expect(cart.items.first.price, 2.50);
      expect(cart.totalPrice, 2.50);
    });

    test('addItem should increment quantity if menu item already exists in cart', () {
      final menuItem = MenuItem(id: '1', name: 'Coffee', description: 'Hot coffee', price: 2.50, imageUrl: '', category: 'TestCategory');
      cartNotifier.addItem(menuItem); // Add first time
      cartNotifier.addItem(menuItem); // Add second time

      final cart = container.read(cartProvider);
      expect(cart.items.length, 1);
      expect(cart.items.first.quantity, 2);
      expect(cart.totalPrice, 5.00);
    });

    test('removeItem should remove an item from the cart', () {
      final menuItem1 = MenuItem(id: '1', name: 'Coffee', description: 'Hot coffee', price: 2.50, imageUrl: '', category: 'TestCategory');
      final menuItem2 = MenuItem(id: '2', name: 'Tea', description: 'Hot tea', price: 2.00, imageUrl: '', category: 'TestCategory');
      cartNotifier.addItem(menuItem1);
      cartNotifier.addItem(menuItem2);

      cartNotifier.removeItem('1');

      final cart = container.read(cartProvider);
      expect(cart.items.length, 1);
      expect(cart.items.first.id, '2');
      expect(cart.totalPrice, 2.00);
    });

    test('clearCart should remove all items from the cart', () {
      final menuItem1 = MenuItem(id: '1', name: 'Coffee', description: 'Hot coffee', price: 2.50, imageUrl: '', category: 'TestCategory');
      final menuItem2 = MenuItem(id: '2', name: 'Tea', description: 'Hot tea', price: 2.00, imageUrl: '', category: 'TestCategory');
      cartNotifier.addItem(menuItem1);
      cartNotifier.addItem(menuItem2);

      cartNotifier.clearCart();

      final cart = container.read(cartProvider);
      expect(cart.items, isEmpty);
      expect(cart.totalPrice, 0.0);
    });

    test('placeOrder should clear the cart after a delay', () async {
      final menuItem = MenuItem(id: '1', name: 'Coffee', description: 'Hot coffee', price: 2.50, imageUrl: '', category: 'TestCategory');
      cartNotifier.addItem(menuItem);
      expect(container.read(cartProvider).items.isNotEmpty, true);

      await cartNotifier.placeOrder();

      final cart = container.read(cartProvider);
      expect(cart.items, isEmpty);
      expect(cart.totalPrice, 0.0);
    });
  });
}
