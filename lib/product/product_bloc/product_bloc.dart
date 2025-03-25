// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_using_bloc/product/models/product.dart';
import 'product_events.dart';
import 'product_states.dart';
import 'package:http/http.dart' as http;

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitialState()) {
    /// * register event handler
    on<FetchProductsEvent>((event, emit) async {
      /// * If currently in loaded state, emit loading more state
      if (state is ProductLoadedState) {
        final currentProducts = (state as ProductLoadedState).products;
        emit(ProductLoadingMoreState(currentProducts: currentProducts));
      } else {
        emit(ProductLoadingState());
      }

      /// * fetch products and wait for the response
      await fetchProducts();
      if (productData.products!.isNotEmpty) {
        /// * add all the loaded products
        products.addAll(productData.products!);

        /// * emit loaded state
        emit(ProductLoadedState(products));
      } else {
        emit(ProductEmptyState());
      }
    });
  }

  /// * pagination variables
  int limit = 10;
  int skip = 0;
  int total = 0;

  /// * product data variables
  ProductResponseModel productData = ProductResponseModel();
  final List<Product> products = [];

  /// * fetch products
  Future<void> fetchProducts() async {
    /// * prepare url with limit(maximum number of products at a time) and skip(products offset count)
    Uri url =
        Uri.parse('https://dummyjson.com/product/?limit=$limit&skip=$skip');

    /// * make a get request to the prepare url and wait for response
    final response = await http.get(url);

    /// * parse response body as json.
    final jsonData = jsonDecode(response.body) as Map<String, dynamic>;

    /// * parse json into ProductData object.
    productData = ProductResponseModel.fromJson(jsonData);

    /// * update pagination properties
    limit = productData.limit!;
    skip = productData.skip! + limit;
    total = productData.total!;

    log('Limit: $limit');
    log('Skip: $skip');
    log('Total: $total');
  }
}
