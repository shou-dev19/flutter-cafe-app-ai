import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/models/cart.dart';
import 'package:flutter_app/models/cart_item.dart';
import 'package:flutter_app/models/menu_item.dart';
import 'package:flutter_app/domain/usecases/place_order_use_case.dart';
import 'package:flutter_app/providers/order_providers.dart';

class CartNotifier extends StateNotifier<Cart> {
  final PlaceOrderUseCase _placeOrderUseCase;

  CartNotifier(this._placeOrderUseCase) : super(Cart());

  void addItem(MenuItem menuItem) {
    final cartItem = CartItem(
      id: menuItem.id,
      name: menuItem.name,
      price: menuItem.price,
      imageUrl: menuItem.imageUrl, // Added
    );
    state = state.addItem(cartItem);
  }

  void removeItem(String itemId) {
    state = state.removeItem(itemId);
  }

  void clearCart() {
    state = state.clearCart();
  }

  Future<void> placeOrder() async {
    if (state.items.isEmpty) {
      // Don't place an order if the cart is empty
      return;
    }
    try {
      await _placeOrderUseCase.execute(state);
      // If the order is successful, clear the cart
      // The README specifies: "「注文確定」ボタンが押下された後、カートエリアは非表示になります。"
      // Clearing the cart will make it disappear as per current logic (cart area shown only if items > 0)
      clearCart();
    } catch (e) {
      // Handle or log the error appropriately
      // For now, just print it. In a real app, you might show a message to the user.
      print("Error placing order: $e");
      // Optionally, rethrow the error if the UI needs to react to it specifically
      // throw e;
    }
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, Cart>((ref) {
  final placeOrderUseCase = ref.watch(placeOrderUseCaseProvider);
  return CartNotifier(placeOrderUseCase);
});
