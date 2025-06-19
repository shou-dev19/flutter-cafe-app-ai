import 'package:flutter_app/models/cart_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CartItem', () {
    test('should create a CartItem with default quantity 1', () {
      final cartItem = CartItem(id: '1', name: 'Coffee', price: 2.50);
      expect(cartItem.id, '1');
      expect(cartItem.name, 'Coffee');
      expect(cartItem.price, 2.50);
      expect(cartItem.quantity, 1);
    });

    test('should create a CartItem with specified quantity', () {
      final cartItem = CartItem(id: '2', name: 'Tea', price: 2.00, quantity: 3);
      expect(cartItem.id, '2');
      expect(cartItem.name, 'Tea');
      expect(cartItem.price, 2.00);
      expect(cartItem.quantity, 3);
    });
  });
}
