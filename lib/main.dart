import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_using_bloc/product/product_bloc/product_bloc.dart';
import 'package:infinite_scroll_using_bloc/product/views/product_view.dart';

main() => runApp(ProductApp());

class ProductApp extends StatelessWidget {
  const ProductApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Infinite Scroll',
        home: ProductView(),
      ),
    );
  }
}
