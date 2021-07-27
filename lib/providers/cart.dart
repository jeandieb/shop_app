import 'package:flutter/cupertino.dart';
import 'package:flutter_complete_guide/screens/products_overview_screen.dart';

class CartItem {
  @required
  final String id;
  @required
  final String title;
  @required
  final double price;
  @required
  final int quantity;

  CartItem({this.id, this.title, this.price, this.quantity});
}

class Cart with ChangeNotifier {
  //map that will map product id to a cart item instance
  //note that prodcut id and cart item id are two different ids
  Map<String, CartItem> _items;

  Map<String, CartItem> get ItemsFilter {
    return {..._items};
  }

  void addItemToCart(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(productId, (existingProduct) {
        return CartItem(
          id: existingProduct.id,
          title: existingProduct.title,
          price: existingProduct.price,
          quantity: existingProduct.quantity + 1,
        );
      });
    } 
    else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                price: price,
                quantity: 1,
              ));
    }
  }
}
