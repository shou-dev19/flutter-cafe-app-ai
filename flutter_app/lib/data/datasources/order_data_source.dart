import 'package:flutter_app/models/cart.dart';

abstract class OrderDataSource {
  Future<void> placeOrder(Cart cart);
}
