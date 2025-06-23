import 'package:flutter_app/data/datasources/order_data_source.dart';
import 'package:flutter_app/models/cart.dart';

class MockOrderDataSource implements OrderDataSource {
  @override
  Future<void> placeOrder(Cart cart) async {
    // Simulate a successful order placement without actual network call
    print("Placing order (mock): \${cart.items.map((e) => e.name).join(', ')}");
    print("Total price: \${cart.totalPrice}");
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate some processing time
    print("Mock order placed successfully.");
  }
}
