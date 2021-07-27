import 'package:flutter/material.dart';

import '../providers/product.dart';
import '../widgets/product_item.dart';
import '../widgets/products_grid.dart';

enum ItemsFilter { FAVORITE, ALL }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              setState(() {
                if (value == ItemsFilter.FAVORITE) {
                  isFavorite = true;
                } else {
                  isFavorite = false;
                }
              });
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text('Favorite'),
                  value: ItemsFilter.FAVORITE,
                ),
                PopupMenuItem(
                  child: Text('All'),
                  value: ItemsFilter.ALL,
                ),
              ];
            },
          ),
        ],
        title: Text("My Shop"),
      ),
      body: ProductsGrid(isFavorite),
    );
  }
}
