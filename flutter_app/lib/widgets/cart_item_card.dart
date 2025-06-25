import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/models/cart_item.dart';
import 'package:flutter_app/providers/cart_provider.dart';
import 'package:flutter_app/models/menu_item.dart'; // Add this import

class CartItemCard extends ConsumerWidget {
  final CartItem cartItem;

  const CartItemCard({Key? key, required this.cartItem}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ListTile(
        leading: Image.asset(cartItem.item.imageUrl, width: 50, height: 50, fit: BoxFit.cover), // Add image
        title: Text(cartItem.item.name, style: const TextStyle(color: Color(0xFFEFEBE9))),
        subtitle: Text('¥${cartItem.item.price.toStringAsFixed(0)}', style: const TextStyle(color: Color(0xFFBDBDBD))),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              color: const Color(0xFFBE9C91),
              onPressed: () {
                ref.read(cartProvider.notifier).removeItem(cartItem.item);
              },
            ),
            Text(cartItem.quantity.toString(), style: Theme.of(context).textTheme.titleMedium?.copyWith(color: const Color(0xFFEFEBE9))),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              color: const Color(0xFFBE9C91),
              onPressed: () {
                ref.read(cartProvider.notifier).addItem(cartItem.item);
              },
            ),
          ],
        ),
      ),
    );
  }
}
