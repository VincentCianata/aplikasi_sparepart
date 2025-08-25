class CartItem {
  final int id;
  final int sparepartId;
  final String name;
  final double price;
  final String image;
  int quantity;

  CartItem({
    required this.id,
    required this.sparepartId,
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      sparepartId: json['sparepart_id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      image: json['image'],
      quantity: json['quantity'],
    );
  }
}
