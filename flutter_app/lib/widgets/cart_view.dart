import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/providers/cart_provider.dart';
import 'package:flutter_app/widgets/cart_item_card.dart';

class CartView extends ConsumerStatefulWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  ConsumerState<CartView> createState() => _CartViewState();
}

class _CartViewState extends ConsumerState<CartView> {
  bool _isExpanded = false;
  final double _collapsedHeight = 60.0; // Height of the collapsed cart bar
  final double _itemHeight = 80.0; // Approximate height of one CartItemCard + padding
  final double _cartActionsHeight = 150.0; // Height for total, button, and padding

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);

    if (cart.items.isEmpty) {
      // Ensure _isExpanded is false when cart becomes empty
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _isExpanded) {
          setState(() {
            _isExpanded = false;
          });
        }
      });
      return const SizedBox.shrink(); // カートが空の場合は何も表示しない
    }

    // Calculate dynamic height for the expanded cart content
    // This includes space for each item, plus the total and order button area.
    final double cartContentHeight = (cart.items.length * _itemHeight) + _cartActionsHeight;
    // Ensure a minimum height for the expanded view, e.g., if there's only one item.
    final double expandedCartHeight = math.max(cartContentHeight, _collapsedHeight + _itemHeight + _cartActionsHeight / 2);


    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Material(
        elevation: 8.0,
        color: Theme.of(context).cardTheme.color ?? Theme.of(context).colorScheme.surface,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Container(
                height: _collapsedHeight,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'カート (${cart.items.length}種類)',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: const Color(0xFFEFEBE9)),
                    ),
                    Row(
                      children: [
                        Text(
                          '合計: \$${cart.totalPrice.toStringAsFixed(2)}',
                           style: Theme.of(context).textTheme.titleMedium?.copyWith(color: const Color(0xFFEFEBE9)),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          _isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                          color: const Color(0xFFEFEBE9),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: _isExpanded ? expandedCartHeight : 0,
              child: SingleChildScrollView( // Added to prevent overflow if content is too tall
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (cart.items.isNotEmpty) // Ensure ListView.builder is only built if items exist
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(), // Important for nested scrolling
                          itemCount: cart.items.length,
                          itemBuilder: (context, index) {
                            return CartItemCard(cartItem: cart.items[index]);
                          },
                        ),
                      const SizedBox(height: 16.0),
                      Text(
                        '合計: \$${cart.totalPrice.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: const Color(0xFFEFEBE9)),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 8.0),
                      ElevatedButton(
                        onPressed: () async {
                          await ref.read(cartProvider.notifier).placeOrder();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('注文が完了しました！')),
                          );
                          setState(() {
                            _isExpanded = false; // Collapse after ordering
                          });
                        },
                        child: const Text('注文確定'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
