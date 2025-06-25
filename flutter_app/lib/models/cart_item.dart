class CartItem {
  final String id;
  final String name;
  final double price;
  final String imageUrl; // Added
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl, // Added
    this.quantity = 1,
  });
}
