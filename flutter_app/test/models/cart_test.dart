import 'package:flutter_app/models/cart.dart';
import 'package:flutter_app/models/cart_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Cart', () {
    test('should create an empty cart', () {
      final cart = Cart();
      expect(cart.items, isEmpty);
      expect(cart.totalPrice, 0.0);
    });

    test('addItem should add a new item to the cart', () {
      final cart = Cart();
      final item = CartItem(id: '1', name: 'Coffee', price: 2.50);
      final updatedCart = cart.addItem(item);

      expect(updatedCart.items.length, 1);
      expect(updatedCart.items.first.id, '1');
      expect(updatedCart.totalPrice, 2.50);
    });

    test('addItem should increment quantity if item already exists', () {
      final item = CartItem(id: '1', name: 'Coffee', price: 2.50);
      final cart = Cart(items: [item]);
      final updatedCart = cart.addItem(CartItem(id: '1', name: 'Coffee', price: 2.50)); // Add same item again

      expect(updatedCart.items.length, 1);
      expect(updatedCart.items.first.quantity, 2);
      expect(updatedCart.totalPrice, 5.00);
    });

    test('removeItem should remove an item from the cart', () {
      final item1 = CartItem(id: '1', name: 'Coffee', price: 2.50);
      final item2 = CartItem(id: '2', name: 'Tea', price: 2.00);
      final cart = Cart(items: [item1, item2]);
      final updatedCart = cart.removeItem('1');

      expect(updatedCart.items.length, 1);
      expect(updatedCart.items.first.id, '2');
      expect(updatedCart.totalPrice, 2.00);
    });

    test('removeItem should do nothing if item not found', () {
      final item1 = CartItem(id: '1', name: 'Coffee', price: 2.50);
      final cart = Cart(items: [item1]);
      final updatedCart = cart.removeItem('2'); // Try to remove non-existent item

      expect(updatedCart.items.length, 1);
      expect(updatedCart.totalPrice, 2.50);
    });

    test('clearCart should remove all items from the cart', () {
      final item1 = CartItem(id: '1', name: 'Coffee', price: 2.50);
      final item2 = CartItem(id: '2', name: 'Tea', price: 2.00);
      final cart = Cart(items: [item1, item2]);
      final updatedCart = cart.clearCart();

      expect(updatedCart.items, isEmpty);
      expect(updatedCart.totalPrice, 0.0);
    });

    test('totalPrice should calculate the correct total', () {
      final item1 = CartItem(id: '1', name: 'Coffee', price: 2.50, quantity: 2);
      final item2 = CartItem(id: '2', name: 'Tea', price: 2.00, quantity: 1);
      final cart = Cart(items: [item1, item2]);

      expect(cart.totalPrice, 7.00); // (2.50 * 2) + (2.00 * 1)
    });
  });
}
