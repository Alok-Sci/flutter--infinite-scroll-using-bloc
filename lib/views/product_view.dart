// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_using_bloc/models/product.dart';
import 'package:infinite_scroll_using_bloc/viewmodels/product_bloc/product_events.dart';
import 'package:infinite_scroll_using_bloc/viewmodels/product_bloc/product_states.dart';
import 'package:infinite_scroll_using_bloc/viewmodels/product_view_model.dart';

class ProductView extends StatelessWidget {
  ScrollController scrollController = ScrollController();
  ProductViewModel productBloc = ProductViewModel();

  ProductView() {
    // productBloc.add(FetchProductsEvent());
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
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
      body: BlocBuilder<ProductViewModel, ProductState>(
        bloc: productBloc,
        builder: (context, state) {
          print('loader------------------------------------------------------');
          if (state is ProductInitialState) {
            print(
                "---------------------------------------------------------ProductInitialState");
            productBloc.add(FetchProductsEvent());
            return _productInitialState();
          } else if (state is ProductLoadingState) {
            print(
                "---------------------------------------------------------ProductLoadingState");
            return _productLoadingState();
          } else if (state is ProductLoadedState) {
            print(
                "---------------------------------------------------------ProductLoadedState");
            return _productLoadedState(state);
          } else {
            return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline),
                  Text('You reached the end.')
                ]);
          }
        },
      ),
    );
  }

  Widget _productLoadedState(ProductLoadedState state) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: GridView.builder(
        controller: scrollController,
        itemCount: state.products.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          log('building items -------------------------->');
          return (state.products.length == productBloc.products)
              ? CircularProgressIndicator()
              : GridTile(
                  child: Card(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: 500),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network('${state.products[index].thumbnail}'),
                            SizedBox(height: 8),
                            Expanded(
                              child: Text(
                                '${state.products[index].title}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            SizedBox(height: 8),
                            Expanded(
                              child:
                                  Text('${state.products[index].description}'),
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

  Widget _productInitialState() {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          
          children: [CircularProgressIndicator(color: Colors.teal.shade900), SizedBox(height: 20), Text('Fetching information.', style: TextStyle(color: Colors.teal.shade900))]),
    );
  }

  Widget _productLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        color: Colors.teal.shade900,
      ),
    );
  }
}
