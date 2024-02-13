import 'package:todak_assessment/object/cart_obj.dart';
import 'package:todak_assessment/object/product_obj.dart';

class Order {
  final List<CartItem> cartItems;
  final String address;
  final double totalPrice;
  final String date;

  Order({
    required this.cartItems,
    required this.address,
    required this.totalPrice,
    required this.date,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final List<dynamic> cartItemsJson = json['cartItems'];
    final cartItems = cartItemsJson.map((item) {
      final productJson = item['product'];
      final product = Product.fromJson(productJson);
      final quantity = item['quantity'];
      return CartItem(product: product, quantity: quantity);
    }).toList();

    return Order(
      cartItems: cartItems,
      address: json['address'],
      totalPrice: json['totalPrice'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> cartItemsJson = cartItems
        .map((cartItem) => {
              'product': cartItem.product.toJson(),
              'quantity': cartItem.quantity,
            })
        .toList();

    return {
      'cartItems': cartItemsJson,
      'address': address,
      'totalPrice': totalPrice,
      'date': date,
    };
  }

  double calculateTotalPrice() {
    double total = 0.0;
    for (var cartItem in cartItems) {
      total += cartItem.product.price * cartItem.quantity;
    }
    return total;
  }
}
