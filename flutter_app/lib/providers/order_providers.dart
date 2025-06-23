import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/data/datasources/mock_order_data_source.dart';
import 'package:flutter_app/data/datasources/order_data_source.dart';
import 'package:flutter_app/data/datasources/remote_order_data_source.dart';
import 'package:flutter_app/data/repositories/order_repository_impl.dart';
import 'package:flutter_app/domain/repositories/order_repository.dart';
import 'package:flutter_app/domain/usecases/place_order_use_case.dart';
import 'package:http/http.dart' as http;

// Define an enum or a const to switch between environments
const bool useMockDataSource = true; // Set to false for production

// Provider for HttpClient, only used by RemoteOrderDataSource
final httpClientProvider = Provider<http.Client>((ref) => http.Client());

// Provider for OrderDataSource
// This will provide either MockOrderDataSource or RemoteOrderDataSource based on the flag
final orderDataSourceProvider = Provider<OrderDataSource>((ref) {
  if (useMockDataSource) {
    return MockOrderDataSource();
  } else {
    final client = ref.watch(httpClientProvider);
    return RemoteOrderDataSource(client);
  }
});

// Provider for OrderRepository
final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final dataSource = ref.watch(orderDataSourceProvider);
  return OrderRepositoryImpl(dataSource);
});

// Provider for PlaceOrderUseCase
final placeOrderUseCaseProvider = Provider<PlaceOrderUseCase>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return PlaceOrderUseCase(repository);
});
