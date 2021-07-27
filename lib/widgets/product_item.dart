import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    print('product item rebuilt..');
    final Product product = Provider.of<Product>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          child: Image.network(product.imageUrl, fit: BoxFit.cover),
          onTap: () => Navigator.of(context)
              .pushNamed(ProductDetailScreen.routeName, arguments: product.id),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          //consumer allows us to listen to changes in provider only in part of the widget
          //will not reun all build when changes are noticed, only the wrapped part 
          leading: Consumer<Product>(
            //use child if there is parts inside the wrapped part that you don't want to update 
            //when something changes, like a text widget... not used in this examples,
            //Demoed at the end of lecture 198
            builder: (ctx, product, child) => IconButton(
              icon: Icon(
                product.isFavorite? Icons.favorite : Icons.favorite_border,
                color:  Theme.of(context).accentColor,
              ),
              onPressed: () {
                product.toggleFavoriteStatus();
              },
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {},
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
