

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
        scaffoldBackgroundColor: const Color(0xFF3E2723), // Dark brown background
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF5D4037), // Medium brown app bar
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFFEFEBE9), // Light beige text
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(
            color: Color(0xFFEFEBE9), // Light beige icons
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFD7CCC8)), // Light brown text
          bodyMedium: TextStyle(color: Color(0xFFD7CCC8)), // Light brown text
          titleLarge: TextStyle(color: Color(0xFFEFEBE9)), // Light beige text for titles
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF4E342E), // Darker brown for cards
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFA1887F), // Lighter brown for buttons
            foregroundColor: const Color(0xFFEFEBE9), // Light beige text on buttons
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Color(0xFF5D4037), // Medium brown for snackbar
          contentTextStyle: TextStyle(color: Color(0xFFEFEBE9)), // Light beige text
        ),
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
        title: const Text('The Cozy Corner'), // Updated title
        centerTitle: false, // Align title to the left
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () {
              // Handle notification tap
            },
          ),
        ],
      ),
      body: Column( // Main layout as a Column
        children: [
          // Placeholder for Header/Banner (e.g., Image or Carousel)
          Container(
            height: 150,
            color: Colors.grey[800], // Placeholder color
            alignment: Alignment.center,
            child: const Text('Special Offers Banner', style: TextStyle(color: Colors.white)),
          ),
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color ?? const Color(0xFFD7CCC8)),
              decoration: InputDecoration(
                hintText: 'Search for coffee, tea, pastries...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                filled: true,
                fillColor: const Color(0xFF4E342E), // Darker brown
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Placeholder for Category Filters
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: ['All', 'Coffee', 'Tea', 'Pastries', 'Sandwiches']
                  .map((category) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Chip(
                          label: Text(category),
                          backgroundColor: const Color(0xFF5D4037), // Medium brown
                          labelStyle: const TextStyle(color: Color(0xFFEFEBE9)), // Light beige text
                        ),
                      ))
                  .toList(),
            ),
          ),
          Expanded( // This will now contain the Row for Menu and Cart
            child: Row(
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
      ), // Closes child Row of Expanded
    ], // Closes children of main Column (body)
  ), // Closes main Column (body)
  bottomNavigationBar: BottomNavigationBar(
    backgroundColor: const Color(0xFF5D4037), // Medium brown
    selectedItemColor: const Color(0xFFEFEBE9), // Light beige
    unselectedItemColor: const Color(0xFFBDBDBD), // Lighter grey
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.favorite_border),
        label: 'Favorites',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        label: 'Profile',
      ),
    ],
    currentIndex: 0, // Default to Home
    onTap: (index) {
      // Handle bottom navigation tap
    },
  ),
); // This closes the Scaffold
  }
}

