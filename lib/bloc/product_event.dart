// In sku_event.dart

part of 'product_bloc.dart';

sealed class ProductBlocEvent {}

class FetchProduct extends ProductBlocEvent {}

class StoreCartItems extends ProductBlocEvent {
  final List<CartItem> cartItems;

  StoreCartItems(this.cartItems);
}
