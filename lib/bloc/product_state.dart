// ignore_for_file: non_constant_identifier_names

part of 'product_bloc.dart';

enum ApiStatus {
  loading,
  success,
  fail,
}

class ProductBlocState extends Equatable {
  final ApiStatus status;
  final List<Product> product;
  const ProductBlocState({
    required this.status,
    required this.product,
  });

  @override
  List<Object?> get props => [product];
}
