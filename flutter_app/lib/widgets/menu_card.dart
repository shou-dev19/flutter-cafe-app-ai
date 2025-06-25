

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/models/cart_item.dart'; // Added for CartItem type
import 'package:flutter_app/providers/cart_provider.dart';
import '../models/menu_item.dart';

class MenuCard extends ConsumerWidget {
  final MenuItem item;


  const MenuCard({
    super.key,
    required this.item,

  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card( // Uses CardTheme from main.dart
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          Expanded(
            flex: 3, // Give more space to the image
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)), // Match card's border radius
              child: Image.asset(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800], // Placeholder color for error
                    child: const Icon(
                        Icons.coffee_maker_outlined,
                        size: 50,
                        color: Color(0xFFEFEBE9) // Light beige icon color
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 2, // Space for text content and button
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 18,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        item.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 12,
                              color: const Color(0xFFBDBDBD),
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '¥${item.price.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: const Color(0xFFBE9C91),
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          final cart = ref.watch(cartProvider);
                          // Attempt to find the item in the cart
                          CartItem? cartItem;
                          try {
                            cartItem = cart.items.firstWhere((ci) => ci.id == item.id);
                          } catch (e) {
                            cartItem = null; // Item not in cart
                          }

                          if (cartItem != null && cartItem.quantity > 0) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, color: Color(0xFFBE9C91)),
                                  iconSize: 20, // Smaller icons
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    ref.read(cartProvider.notifier).decrementItem(item.id);
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                  child: Text(cartItem.quantity.toString(), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14, color: const Color(0xFFEFEBE9))),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline, color: Color(0xFFBE9C91)),
                                  iconSize: 20, // Smaller icons
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    // If item is not in cart yet (quantity 0), addItem. Otherwise, increment.
                                    // This case should ideally be handled by incrementItem if it can add item if not present.
                                    // For now, assuming incrementItem works on existing items.
                                    // If it was 0, it means it was just removed by decrement, so adding it back via addItem or increment.
                                    // Let's ensure addItem is called if quantity is 0 or item is null.
                                     final existingCartItem = cart.items.any((ci) => ci.id == item.id);
                                     if (!existingCartItem) {
                                       ref.read(cartProvider.notifier).addItem(item);
                                     } else {
                                       ref.read(cartProvider.notifier).incrementItem(item.id);
                                     }
                                  },
                                ),
                              ],
                            );
                          } else {
                            return ElevatedButton(
                              onPressed: () {
                                ref.read(cartProvider.notifier).addItem(item);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              child: const Text('Add'),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

