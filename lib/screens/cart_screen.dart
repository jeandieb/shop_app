import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/orders_screen.dart';
import 'package:provider/provider.dart';

//we now have two classes called CartItem
//use 'as' to distinguis between them
//another solution would be to not import CartItem from providers/cart.dart
//because we do not need it in here, so we can import Cart only using the following command
//import '../providers/cart.dart' show Cart;
import '../providers/cart.dart';
import '../widgets/cart_item.dart' as ct;
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Shopping Cart')),
      body: Column(
        children: [
          Card(
              margin: EdgeInsets.all(15.0),
              elevation: 10.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total', style: TextStyle(fontSize: 20)),
                    Spacer(),
                    Chip(
                      label: Text(
                        '\$${cart.getTotal}',
                        style: TextStyle(
                          color: Theme.of(context).primaryTextTheme.title.color,
                        ),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    TextButton(
                        onPressed: () {
                          Provider.of<Orders>(context, listen: false).addOrder(
                              cart.items.values.toList(), cart.getTotal);
                          cart.clearCart();
                        },
                        child: Text('ORDER NOW'))
                  ],
                ),
              )),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.numProducts,
              itemBuilder: (context, index) => ct.CartItem(
                cart.items.values.toList()[index].id,
                cart.items.keys.toList()[index],
                cart.items.values.toList()[index].title,
                cart.items.values.toList()[index].quantity,
                cart.items.values.toList()[index].price,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
