
import 'package:flutter_app/models/menu_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class CartNotifier extends StateNotifier<List<MenuItem>> {
  CartNotifier() : super([]);

  void addItem(MenuItem item) {
    state = [...state, item];
  }

  void removeItem(MenuItem item) {
    state = state.where((cartItem) => cartItem.id != item.id).toList();
  }

  void clearCart() {
    state = [];
  }

  double get totalPrice => state.fold(0, (total, current) => total + current.price);
}
