

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
        cardTheme: CardThemeData( // Changed CardTheme to CardThemeData
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

class MenuScreen extends ConsumerStatefulWidget { // Change to ConsumerStatefulWidget
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> { // Create State class
  String _selectedCategory = 'すべて'; // Add state for selected category

  @override
  Widget build(BuildContext context) { // Remove WidgetRef from build method parameters
    final ref = this.ref; // Get ref from state
    // Filter menu items based on selected category
    final filteredMenuItems = _selectedCategory == 'すべて'
        ? mockMenuItems
        : mockMenuItems.where((item) => item.category == _selectedCategory).toList();

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
          SizedBox(
            height: 150,
            width: double.infinity, // Make the image take the full width
            child: Image.asset(
              'assets/cafe_top.jpeg',
              fit: BoxFit.cover, // Cover the area, cropping if necessary
            ),
          ),

          // Placeholder for Category Filters
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: ['すべて', 'コーヒー', 'お茶', 'パスタ', 'サンドイッチ'] // Updated categories
                  .map((category) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ChoiceChip( // Changed to ChoiceChip for selection indication
                          label: Text(category),
                          selected: _selectedCategory == category, // Set selected state
                          onSelected: (selected) { // Handle selection
                            if (selected) {
                              setState(() {
                                _selectedCategory = category;
                              });
                            }
                          },
                          backgroundColor: const Color(0xFF5D4037), // Medium brown
                          selectedColor: const Color(0xFFA1887F), // Lighter brown for selected
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
                itemCount: filteredMenuItems.length, // Use filtered list
                itemBuilder: (context, index) {
                  final item = filteredMenuItems[index]; // Use filtered list
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
        ], // Closes children of Row (from line 137)
      ), // Closes Row (from line 136)
    ), // Closes Expanded (from line 135)
  ], // Closes children list of main Column (from line 91)
), // Closes main Column (body - from line 90)

); // This closes the Scaffold
  }
}

