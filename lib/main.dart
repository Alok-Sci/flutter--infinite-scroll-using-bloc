import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_using_bloc/viewmodels/product_view_model.dart';
import 'package:infinite_scroll_using_bloc/views/product_view.dart';

main() => runApp(ProductApp());

class ProductApp extends StatelessWidget {
  const ProductApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Infinite Scroll',
        home: ProductView(),
      ),
    );
  }
}

// main() {
//   ProductViewModel pvm = ProductViewModel();
//   pvm.fetchProducts();
// }
