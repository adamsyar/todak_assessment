// ignore_for_file: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todak_assessment/api/product_api.dart';
import 'package:todak_assessment/object/product_obj.dart';

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
  }
}
