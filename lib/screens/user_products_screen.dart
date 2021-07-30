import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/user_product_item.dart';
import '../providers/products.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user_products';
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Products'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.add)),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (_, index) {
              return Column(
                children: [
                  UserProduct(productsData.items[index].title,
                      productsData.items[index].imageUrl),
                  Divider(color: Theme.of(context).primaryColor, thickness: 1,),
                ],
              );
            }),
      ),
    );
  }
}
