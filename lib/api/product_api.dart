import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todak_assessment/object/product_obj.dart';

class ProductApi {
  static const String apiUrl = 'https://dummyjson.com/products';

  static Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        return _parseProducts(response.body);
      } else {
        throw ApiException('Failed to load products. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Failed to fetch products: $e');
    }
  }

  static List<Product> _parseProducts(String responseBody) {
    final parsed = jsonDecode(responseBody)['products'] as List<dynamic>;
    return parsed.map<Product>((json) => Product.fromJson(json)).toList();
  }
}

class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}
