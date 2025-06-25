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
        title: Text(cartItem.name, style: const TextStyle(color: Color(0xFFEFEBE9))),
        subtitle: Text('\$${cartItem.price.toStringAsFixed(2)} x ${cartItem.quantity}', style: const TextStyle(color: Color(0xFFBDBDBD))),
        trailing: SizedBox(
          width: 120, // Constrain the width of the trailing widget
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, color: Color(0xFFEFEBE9)),
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  ref.read(cartProvider.notifier).decrementItem(cartItem.id);
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0), // Reduced padding
                  child: Text(
                    cartItem.quantity.toString(),
                    style: const TextStyle(color: Color(0xFFEFEBE9), fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: Color(0xFFEFEBE9)),
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  ref.read(cartProvider.notifier).incrementItem(cartItem.id);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Color(0xFFEFEBE9)),
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  ref.read(cartProvider.notifier).removeItem(cartItem.id);
                },
              ),
            ],
          ),
        ),

      ),
    );
  }
}
