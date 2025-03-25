import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_using_bloc/product/models/product.dart';
import 'package:infinite_scroll_using_bloc/product/product_bloc/product_events.dart';
import 'package:infinite_scroll_using_bloc/product/product_bloc/product_states.dart';
import 'package:infinite_scroll_using_bloc/product/product_bloc/product_bloc.dart';

class ProductView extends StatelessWidget {
  /// * ScrollController for listening to the changes in scroll state.
  final ScrollController scrollController = ScrollController();
  final ProductBloc productBloc = ProductBloc();

  /// * constructure
  ProductView({super.key}) {
    /// * add listener
    scrollController.addListener(() {
      /// when scrolled to bottom,
      /// add FetchProductsEvent to ProductBloc to trigger the event handler
      /// to emit the appropriate state
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        productBloc.add(FetchProductsEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal.shade900,
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        bloc: productBloc,
        builder: (context, state) {
          /// * if initial state then add FetchProductsEvent event to ProductBloc, to emit appropriate state.
          if (state is ProductInitialState) {
            productBloc.add(FetchProductsEvent());
            return _productInitialState();
          } else if (state is ProductLoadingState) {
            return _productLoadingState();
          } else if (state is ProductLoadedState ||
              state is ProductLoadingMoreState) {
            return _productLoadedState(
              (state is ProductLoadedState)
                  ? state.products
                  : (state as ProductLoadingMoreState).currentProducts,
            );
          } else if (state is ProductErrorState) {
            return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.error, color: Colors.red, size: 20),
                    Text(
                      'Something went wrong! Please try again after sometime.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
            );
          } else {
            return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.shopping_bag, color: Colors.teal, size: 20),
                    Text('No products found.'),
                  ]),
            );
          }
        },
      ),
    );
  }

  /// * loaded state - UI
  Widget _productLoadedState(List<Product> products) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: GridView.builder(
        controller: scrollController,

        /// * increment product length by 1 for loading indicator
        itemCount: products.length + 1,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (context, index) {
          /// * if last item, display loading indicator
          if (index == products.length &&
              products.length != productBloc.total) {
            return _buildBottomLoader();
          }
          return GridTile(
            child: Card(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            '${products[index].thumbnail}',
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${products[index].title}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${products[index].description}',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// *  build the bottom loader
  Widget _buildBottomLoader() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.teal.shade900,
          ),
          SizedBox(height: 10),
          Text(
            'Loading more...',
            style: TextStyle(
              color: Colors.teal.shade900,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// * initial state - UI
  Widget _productInitialState() {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.teal.shade900),
            SizedBox(height: 20),
            Text('Fetching information.',
                style: TextStyle(color: Colors.teal.shade900))
          ]),
    );
  }

  /// * loading state - UI
  Widget _productLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.teal.shade900,
          ),
          const SizedBox(height: 20),
          Text('Fetching products...')
        ],
      ),
    );
  }
}
