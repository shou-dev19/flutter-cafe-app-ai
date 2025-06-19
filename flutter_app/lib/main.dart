

import 'package:flutter/material.dart';
import 'package:flutter_app/data/menu_data.dart';
import 'package:flutter_app/models/menu_item.dart';
import 'package:flutter_app/providers/cart_provider.dart';
import 'package:flutter_app/widgets/cart/cart_area.dart';
import 'package:flutter_app/widgets/menu_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
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

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('メニュー'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300, // Maximum width of each card
                  childAspectRatio: 0.7, // Aspect ratio of each card
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: mockMenuItems.length,
                itemBuilder: (context, index) {
                  final item = mockMenuItems[index];
                  return MenuCard(
                    item: item,
                    onAddToCart: () {
                      ref.read(cartNotifierProvider.notifier).addItem(item);
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
          const CartArea(),
        ],
      ),
    );
  }
}

