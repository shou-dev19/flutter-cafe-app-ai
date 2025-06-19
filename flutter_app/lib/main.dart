

import 'package:flutter/material.dart';
import 'package:flutter_app/data/menu_data.dart';
import 'package:flutter_app/models/menu_item.dart';
import 'package:flutter_app/widgets/menu_card.dart';
import 'package:flutter_app/widgets/cart_view.dart'; // Import CartView
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:flutter_app/providers/cart_provider.dart'; // Import CartProvider

void main() {
  runApp(
    const ProviderScope( // Wrap with ProviderScope
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'カフェ注文アプリ',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MenuScreen(),
    );
  }
}

class MenuScreen extends ConsumerWidget { // Change to ConsumerWidget
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) { // Add WidgetRef
    return Scaffold(
      appBar: AppBar(
        title: const Text('メニュー'),
        centerTitle: true,
      ),
      body: Row( // Use Row to display menu and cart side-by-side
        children: [
          Expanded( // Menu takes up available space
            flex: 3, // Adjust flex factor as needed
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: mockMenuItems.length,
                itemBuilder: (context, index) {
                  final item = mockMenuItems[index];
                  return MenuCard(
                    item: item,
                    onAddToCart: () {
                      ref.read(cartProvider.notifier).addItem(item); // Use Riverpod notifier
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${item.name}をカートに追加しました'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          const Expanded( // CartView takes up remaining space
            flex: 1, // Adjust flex factor as needed
            child: CartView(),
          ),
        ],
      ),
    );
  }
}

