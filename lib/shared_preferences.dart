import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todak_assessment/object/cart_obj.dart';
import 'package:todak_assessment/object/order_obj.dart';
import 'package:todak_assessment/object/product_obj.dart';
import 'package:todak_assessment/object/profile_obj.dart';

class SharedPreferencesHandler {
  static const String _cartKey = 'cart';
  static const String _profileKey = 'profile';
  static const String _orderKey = 'orders';

  static Future<bool> saveProfile(ProfileInfo profile) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String profileJson = jsonEncode(profile.toJson());
      await prefs.setString(_profileKey, profileJson);
      return true;
    } catch (e) {
      print('Error saving profile: $e');
      return false;
    }
  }

  static Future<ProfileInfo> getProfile() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? profileJson = prefs.getString(_profileKey);
      if (profileJson != null) {
        final Map<String, dynamic> decoded = jsonDecode(profileJson);
        final ProfileInfo profile = ProfileInfo.fromJson(decoded);
        return profile;
      }
      return getDefaultProfile();
    } catch (e) {
      return getDefaultProfile();
    }
  }

  static Future<bool> addAddress(String newAddress) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final ProfileInfo profile = await getProfile();
      profile.addresses.add(newAddress);
      final String updatedProfileJson = jsonEncode(profile.toJson());
      await prefs.setString(_profileKey, updatedProfileJson);
      return true;
    } catch (e) {
      print('Error adding address: $e');
      return false;
    }
  }

  static ProfileInfo getDefaultProfile() {
    return ProfileInfo(
      name: 'Adam Amsyar',
      imagePath: 'assets/avatar1.png',
      addresses: [
        'No 1, Jalan Desa Aman S10/1 Desa Aman, 09410 Padang Serai Kedah',
        'No 2, Jalan Desa Aman S10/1 Desa Aman, 09410 Padang Serai Kedah',
      ],
    );
  }

  static Future<bool> saveCart(List<CartItem> cartItemsToAdd) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? cartJsonString = prefs.getString(_cartKey);
      List<CartItem> existingCartItems = [];

      if (cartJsonString != null) {
        final List<dynamic> existingCartJson = jsonDecode(cartJsonString);
        existingCartItems = existingCartJson.map((json) {
          final productJson = json['product'];
          final product = Product.fromJson(productJson);
          final quantity = json['quantity'];
          return CartItem(product: product, quantity: quantity);
        }).toList();
      }

      final List<CartItem> updatedCartItems = List.from(existingCartItems)
        ..addAll(cartItemsToAdd);

      final List<Map<String, dynamic>> updatedCartJson = updatedCartItems
          .map((cartItem) => {
                'product': cartItem.product.toJson(),
                'quantity': cartItem.quantity,
              })
          .toList();

      await prefs.setString(_cartKey, jsonEncode(updatedCartJson));
      return true;
    } catch (e) {
      print('Error saving cart: $e');
      return false;
    }
  }

  static Future<List<CartItem>> getCart() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? cartJson = prefs.getString(_cartKey);
      if (cartJson != null) {
        final List<dynamic> decoded = jsonDecode(cartJson);
        return decoded.map((item) {
          final productJson = item['product'];
          final product = Product.fromJson(productJson);
          final quantity = item['quantity'];
          return CartItem(product: product, quantity: quantity);
        }).toList();
      }
      return [];
    } catch (e) {
      print('Error getting cart: $e');
      return [];
    }
  }

  static Future<double> getTotalPriceInCart() async {
    try {
      final List<CartItem> cartItems = await getCart();
      double totalPrice = 0;

      for (CartItem cartItem in cartItems) {
        totalPrice += cartItem.product.price * cartItem.quantity;
      }

      return totalPrice;
    } catch (e) {
      print('Error calculating total price: $e');
      return 0.0;
    }
  }

  static Future<bool> clearCart() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cartKey);
      return true;
    } catch (e) {
      print('Error clearing cart: $e');
      return false;
    }
  }

  static Future<bool> removeCartItem(CartItem cartItemToRemove) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? cartJsonString = prefs.getString(_cartKey);
      if (cartJsonString != null) {
        final List<dynamic> existingCartJson = jsonDecode(cartJsonString);
        List<dynamic> updatedCartJson = existingCartJson.where((json) {
          final productJson = json['product'];
          final product = Product.fromJson(productJson);
          final quantity = json['quantity'];
          final existingCartItem =
              CartItem(product: product, quantity: quantity);
          return existingCartItem.product.id != cartItemToRemove.product.id;
        }).toList();

        await prefs.setString(_cartKey, jsonEncode(updatedCartJson));
        return true;
      }

      return false;
    } catch (e) {
      print('Error removing cart item: $e');
      return false;
    }
  }

  static Future<bool> saveOrder(Order order) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<Order> orders = await getOrders();
      orders.add(order);
      final List<String> orderJsonList =
          orders.map((order) => jsonEncode(order.toJson())).toList();
      await prefs.setStringList(_orderKey, orderJsonList);
      return true;
    } catch (e) {
      print('Error saving order: $e');
      return false;
    }
  }

  static Future<List<Order>> getOrders() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String>? orderJsonList = prefs.getStringList(_orderKey);
      if (orderJsonList != null) {
        return orderJsonList.map((orderJson) {
          final Map<String, dynamic> decoded = jsonDecode(orderJson);
          return Order.fromJson(decoded);
        }).toList();
      }
      return [];
    } catch (e) {
      print('Error getting orders: $e');
      return [];
    }
  }
}
