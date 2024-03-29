import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            height: 150,
            width: double.infinity,
            color: Colors.brown,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Best Shop App Ever!',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          Container(
            color: Theme.of(context).accentColor,
            child: ListTile(
              leading: Icon(
                Icons.shop,
                size: 30,
              ),
              title: Text('SHOP'),
              onTap: () => Navigator.pushReplacementNamed(context, '/'),
            ),
          ),
          Divider(
            color: Colors.brown,
            height: 1,
            thickness: 1,
          ),
          Container(
            color: Theme.of(context).accentColor,
            child: ListTile(
              leading: Icon(
                Icons.payment,
                size: 30,
              ),
              title: Text('MY ORDERS'),
              onTap: () => Navigator.pushNamed(context, OrdersScreen.routeName),
            ),
          ),
          Divider(
            color: Colors.brown,
            height: 1,
            thickness: 1,
          ),
          Container(
            color: Theme.of(context).accentColor,
            child: ListTile(
              leading: Icon(
                Icons.manage_accounts,
                size: 30,
              ),
              title: Text('MANAGE PRODUCTS'),
              onTap: () =>
                  Navigator.pushNamed(context, UserProductsScreen.routeName),
            ),
          ),
          Divider(
            color: Colors.brown,
            height: 1,
            thickness: 1,
          ),
          Container(
            color: Theme.of(context).accentColor,
            child: ListTile(
              leading: Icon(
                Icons.exit_to_app,
                size: 30,
              ),
              title: Text('Log Out'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Auth>(context, listen: false).logout();
              },
            ),
          ),
        ],
      ),
    );
  }
}
