import 'package:flutter_app/data/datasources/order_data_source.dart';
import 'package:flutter_app/domain/repositories/order_repository.dart';
import 'package:flutter_app/models/cart.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderDataSource _dataSource;

  OrderRepositoryImpl(this._dataSource);

  @override
  Future<void> placeOrder(Cart cart) async {
    await _dataSource.placeOrder(cart);
  }
}
