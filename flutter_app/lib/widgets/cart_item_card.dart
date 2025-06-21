import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/models/cart_item.dart';
import 'package:flutter_app/providers/cart_provider.dart';

class CartItemCard extends ConsumerWidget {
  final CartItem cartItem;

  const CartItemCard({Key? key, required this.cartItem}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ListTile(
        title: Text(cartItem.name),
        subtitle: Text('\$${cartItem.price.toStringAsFixed(2)} x ${cartItem.quantity}'),
        trailing: IconButton(
          icon: const Icon(Icons.remove_shopping_cart),
          onPressed: () {
            ref.read(cartProvider.notifier).removeItem(cartItem.id);
          },
        ),
      ),
    );
  }
}
