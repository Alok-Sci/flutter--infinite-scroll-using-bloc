import 'package:infinite_scroll_using_bloc/product/models/product.dart';

/// * base state class
abstract class ProductState {}

/// * initial state [before any products are loaded]
class ProductInitialState extends ProductState {
  List<Product> products = [];
}

/// * loading state [when products are loading]
class ProductLoadingState extends ProductState {}

/// * loaded state [when products has loaded]
class ProductLoadedState extends ProductState {
  final List<Product> products;
  ProductLoadedState(this.products);
}

/// * empty state [when products has loaded, but there is no product]
class ProductEmptyState extends ProductState {}

/// * loading more state [when products are present and loading more products]
class ProductLoadingMoreState extends ProductState {
  final List<Product> currentProducts;

  ProductLoadingMoreState({required this.currentProducts});
}

/// * error state [when encoutered error while fetching products]
class ProductErrorState extends ProductState {}
