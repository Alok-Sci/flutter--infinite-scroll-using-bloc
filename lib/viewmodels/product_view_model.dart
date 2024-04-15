// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_using_bloc/models/product.dart';
import 'product_bloc/product_events.dart';
import 'product_bloc/product_states.dart';
import 'package:http/http.dart' as http;

class ProductViewModel extends Bloc<ProductEvent, ProductState> {
  ProductViewModel() : super(ProductInitialState()) {
    on<FetchProductsEvent>((event, emit) async {
      print('---------------------------------------------------------------productLoadingState');

      if (total % limit == 0 && total <= limit+skip && total != 0) {
        emit(NoMoreProductState());
        print('---------------------------------------------------------------productNoMoreProductState');
      }

      await fetchProducts();
      if (productData.products!.isNotEmpty) {

        products.addAll(productData.products!);
        emit(ProductLoadedState(products));
        print(
            '---------------------------------------------------------------productLoadedState');
      } 
      else if (skip == 0) {
        emit(ProductLoadingState());
      }
    });
  }

  int limit = 10;
  int skip = 0;
  int total = 0;
  ProductData productData = ProductData();
  final List<Product> products = [];

  Future<void> fetchProducts() async {
    Uri url =
        Uri.parse('https://dummyjson.com/product/?limit=${limit}&skip=${skip}');

    final response = await http.get(url);

    final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
    productData = ProductData.fromJson(jsonData);
    
    limit = productData.limit!;
    skip = productData.skip! + limit;
    total = productData.total!;

    print('---------------limit$limit');
    print('---------------skip$skip');
    print('---------------total$total');
  }
}
