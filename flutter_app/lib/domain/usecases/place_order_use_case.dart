import 'package:flutter_app/domain/repositories/order_repository.dart';
import 'package:flutter_app/models/cart.dart';

class PlaceOrderUseCase {
  final OrderRepository _orderRepository;

  PlaceOrderUseCase(this._orderRepository);

  Future<void> execute(Cart cart) async {
    await _orderRepository.placeOrder(cart);
  }
}
