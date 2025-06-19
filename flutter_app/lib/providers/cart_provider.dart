import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/models/cart.dart';
import 'package:flutter_app/models/cart_item.dart';
import 'package:flutter_app/models/menu_item.dart';

class CartNotifier extends StateNotifier<Cart> {
  CartNotifier() : super(Cart());

  void addItem(MenuItem menuItem) {
    final cartItem = CartItem(
      id: menuItem.id,
      name: menuItem.name,
      price: menuItem.price,
    );
    state = state.addItem(cartItem);
  }

  void removeItem(String itemId) {
    state = state.removeItem(itemId);
  }

  void clearCart() {
    state = state.clearCart();
  }

  // Mock server interaction
  Future<void> placeOrder() async {
    // Simulate a network request
    await Future.delayed(const Duration(seconds: 1));
    print("Order placed for items: \${state.items.map((e) => e.name).join(', ')}");
    print("Total price: \${state.totalPrice}");
    clearCart();
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, Cart>((ref) {
  return CartNotifier();
});
