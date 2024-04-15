import 'package:infinite_scroll_using_bloc/models/product.dart';

abstract class ProductState {}

class ProductInitialState extends ProductState {
  List<Product> products = [];
  ProductInitialState();
}

class ProductLoadingState extends ProductState {}

class ProductLoadedState extends ProductState {
  final List<Product> products;
  ProductLoadedState(this.products);
}

class NoMoreProductState extends ProductState {}
