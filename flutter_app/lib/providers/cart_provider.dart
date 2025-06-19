
import 'package:flutter_app/models/menu_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_provider.g.dart';

@riverpod
class CartNotifier extends _$CartNotifier {
  @override
  List<MenuItem> build() {
    return [];
  }

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
