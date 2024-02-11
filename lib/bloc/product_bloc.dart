// ignore_for_file: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todak_assessment/api/product_api.dart';
import 'package:todak_assessment/object/cart_obj.dart';
import 'package:todak_assessment/object/product_obj.dart';
import 'package:todak_assessment/screen_content/cart.dart';
import 'package:todak_assessment/shared_preferences.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductBlocEvent, ProductBlocState> {
  final ProductApi productApi;

  ProductBloc(this.productApi)
      : super(const ProductBlocState(
          status: ApiStatus.loading,
          product: [],
        )) {
    on<FetchProduct>((event, emit) async {
      try {
        final List<Product> fetchedProducts = await ProductApi.fetchProducts();

        emit(ProductBlocState(
            status: ApiStatus.success, product: fetchedProducts));
      } catch (e) {
        emit(const ProductBlocState(status: ApiStatus.fail, product: []));
      }
    });
    on<StoreCartItems>((event, emit) async {
      try {
        await SharedPreferencesHandler.saveCart(event.cartItems);

        final List<CartItem> cart = await SharedPreferencesHandler.getCart();
        print('Cart Items: $cart');
      } catch (e) {
        print(e);
      }
    });
  }
}
