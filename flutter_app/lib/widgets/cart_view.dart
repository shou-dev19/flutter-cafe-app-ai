import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/providers/cart_provider.dart';
import 'package:flutter_app/widgets/cart_item_card.dart';

class CartView extends ConsumerWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    if (cart.items.isEmpty) {
      return const SizedBox.shrink(); // カートが空の場合は何も表示しない
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      // Use cardTheme color for background to match the menu screen style
      color: Theme.of(context).cardTheme.color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'カート',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                return CartItemCard(cartItem: cart.items[index]);
              },
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            '合計: \$${cart.totalPrice.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: () async {
              await ref.read(cartProvider.notifier).placeOrder();
              // Optionally, show a confirmation message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('注文が完了しました！')),
              );
            },
            child: const Text('注文確定'),
          ),
        ],
      ),
    );
  }
}
