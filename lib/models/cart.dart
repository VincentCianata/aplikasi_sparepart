import 'sparepart.dart';

class CartItem {
  final SparePart sparepart;
  int quantity;

  CartItem({required this.sparepart, this.quantity = 1});
}

class Cart {
  static final List<CartItem> items = [];

  static void addItem(SparePart sparepart) {
    final index = items.indexWhere(
      (cartItem) => cartItem.sparepart.id == sparepart.id,
    );
    if (index != -1) {
      items[index].quantity++;
    } else {
      items.add(CartItem(sparepart: sparepart));
    }
  }

  static void removeItem(SparePart sparepart) {
    final index = items.indexWhere(
      (cartItem) => cartItem.sparepart.id == sparepart.id,
    );
    if (index != -1) {
      if (items[index].quantity > 1) {
        items[index].quantity--;
      } else {
        items.removeAt(index);
      }
    }
  }

  static double get totalPrice {
    double total = 0;
    for (var cartItem in items) {
      total += cartItem.sparepart.price * cartItem.quantity;
    }
    return total;
  }
}
