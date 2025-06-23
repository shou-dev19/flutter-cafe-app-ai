import 'package:flutter_app/domain/repositories/order_repository.dart';
import 'package:flutter_app/models/cart.dart';

class MockOrderRepository implements OrderRepository {
  int placeOrderCallCount = 0;
  Cart? lastCart;
  bool shouldThrowError = false;
  Exception? errorToThrow;

  @override
  Future<void> placeOrder(Cart cart) async {
    placeOrderCallCount++;
    lastCart = cart;
    if (shouldThrowError) {
      if (errorToThrow != null) {
        throw errorToThrow!;
      }
      throw Exception('MockOrderRepository error');
    }
    return Future.value();
  }

  void reset() {
    placeOrderCallCount = 0;
    lastCart = null;
    shouldThrowError = false;
    errorToThrow = null;
  }
}
