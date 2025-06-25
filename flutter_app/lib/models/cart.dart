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

  Cart incrementItemQuantity(String itemId) {
    final existingItemIndex = items.indexWhere((cartItem) => cartItem.id == itemId);
    if (existingItemIndex != -1) {
      final updatedItems = List<CartItem>.from(items);
      updatedItems[existingItemIndex].quantity++;
      return Cart(items: updatedItems);
    }
    return this; // Item not found, return current cart
  }

  Cart decrementItemQuantity(String itemId) {
    final existingItemIndex = items.indexWhere((cartItem) => cartItem.id == itemId);
    if (existingItemIndex != -1) {
      final updatedItems = List<CartItem>.from(items);
      if (updatedItems[existingItemIndex].quantity > 1) {
        updatedItems[existingItemIndex].quantity--;
        return Cart(items: updatedItems);
      } else {
        // If quantity is 1, remove the item
        return Cart(items: items.where((i) => i.id != itemId).toList());
      }
    }
    return this; // Item not found, return current cart
  }

  Cart removeItem(String itemId) { // This method is kept for direct removal if needed
    return Cart(items: items.where((item) => item.id != itemId).toList());
  }

  Cart clearCart() {
    return Cart(items: []);
  }
}
