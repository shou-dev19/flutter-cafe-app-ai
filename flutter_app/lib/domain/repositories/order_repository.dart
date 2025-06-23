import 'package:flutter_app/models/cart.dart';

abstract class OrderRepository {
  Future<void> placeOrder(Cart cart);
}
