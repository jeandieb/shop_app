import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/product.dart';

class ProductDetailScreen extends StatelessWidget {

  static const String routeName = '/product-details';

  @override
  Widget build(BuildContext context) {
    final String productId = ModalRoute.of(context).settings.arguments as String;
    //Provier.of<Products>(context).items.firstWhere((product) => product.id == productId);
    
    //all widgets that use Provider.of are rebuilt every time Products changes
    //listen set to false to stop the wiget from rebuilding
    final productsData = Provider.of<Products>(context, listen: false);

    final Product loadedProduct  = productsData.findById(productId);
     

    return Scaffold(
      appBar: AppBar(title: Text(loadedProduct.title),),
      
    );
  }
}