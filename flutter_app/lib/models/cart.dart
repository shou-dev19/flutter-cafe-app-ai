import 'package:flutter_app/models/cart_item.dart';

class Cart {
  final List<CartItem> items;

  Cart({this.items = const []});

  double get totalPrice {
    return items.fold(0, (total, current) => total + current.price * current.quantity);
  }

  Cart addItem(CartItem item) {
    final existingItemIndex = items.indexWhere((cartItem) => cartItem.id == item.id);
    if (existingItemIndex != -1) {
      final updatedItems = List<CartItem>.from(items);
      updatedItems[existingItemIndex].quantity++;
      return Cart(items: updatedItems);
    } else {
      return Cart(items: [...items, item]);
    }
  }

  Cart removeItem(String itemId) {
    return Cart(items: items.where((item) => item.id != itemId).toList());
  }

  Cart clearCart() {
    return Cart(items: []);
  }
}
