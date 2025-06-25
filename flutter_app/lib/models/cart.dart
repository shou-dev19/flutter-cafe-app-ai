import 'package:flutter_app/models/cart_item.dart';

class Cart {
  final List<CartItem> items;

  Cart({this.items = const []});

  double get totalPrice {
    return items.fold(0, (total, current) => total + current.price * current.quantity);
  }

  Cart addItem(CartItem newItem) {
    final existingItemIndex = items.indexWhere((cartItem) => cartItem.id == newItem.id);

    if (existingItemIndex != -1) {
      // Item exists, increment its quantity by creating a new CartItem
      final updatedItems = List<CartItem>.from(items);
      final existingItem = items[existingItemIndex];
      updatedItems[existingItemIndex] = CartItem(
        id: existingItem.id,
        name: existingItem.name,
        price: existingItem.price,
        quantity: existingItem.quantity + 1,
      );
      return Cart(items: updatedItems);
    } else {
      // Item does not exist, add it to the list
      // newItem comes with quantity 1 by default from CartItem constructor
      return Cart(items: [...items, newItem]);
    }
  }

  Cart removeItem(String itemId) {
    return Cart(items: items.where((item) => item.id != itemId).toList());
  }

  Cart clearCart() {
    return Cart(items: []);
  }

  Cart updateItemQuantity(String itemId, int newQuantity) {
    final itemIndex = items.indexWhere((item) => item.id == itemId);

    if (itemIndex == -1) { // Item not found
      return this; // Or throw an error, or handle as appropriate
    }

    // If the new quantity is 0 or less, remove the item using existing logic
    if (newQuantity <= 0) {
      return removeItem(itemId);
    }

    // Create a new list of items
    final updatedItems = List<CartItem>.from(items);

    // Get the original item to copy its properties
    final originalItem = items[itemIndex]; // Use items directly for original state

    // Create a new CartItem instance with the updated quantity
    updatedItems[itemIndex] = CartItem(
      id: originalItem.id,
      name: originalItem.name,
      price: originalItem.price,
      quantity: newQuantity
    );

    return Cart(items: updatedItems);
  }
}
